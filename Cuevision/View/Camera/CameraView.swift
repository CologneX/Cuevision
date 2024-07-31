//
//  CameraPreview.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 18/07/24.
//

import SwiftUI
import Combine
import AVFoundation
import PhotosUI
import Photos

struct CameraView: View {
    @StateObject var cameraModel: CameraModel
    @StateObject var ballClassificationModel: BilliardBallClassifier
    @StateObject var navigationVM : NavigationViewModel
    @State private var selectedPhotoFromPicker: PhotosPickerItem? = nil
    @State private var currentZoomFactor: CGFloat = 1.0
    @State private var deviceOrientation: UIDeviceOrientation = .unknown
    @State private var photoSource: PhotoSource? = nil
    @State private var displayedPhoto: UIImage? = nil
    /// isShowingPhotoDisplay should be onChange
    @State private var isShowingPhotoDisplay = false
    @State private var mostRecentImage: UIImage? = nil
    @State private var isShowingCameraGuideline = false
    
    @Environment(\.dismiss) private var dismiss
    var captureButton: some View {
        Button(action: {
            cameraModel.capturePhoto()
        }, label: {
            Circle()
                .foregroundColor(.white)
                .frame(width: 80, height: 80, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.8), lineWidth: 2)
                        .frame(width: 65, height: 65, alignment: .center)
                )
        })
        .onChange(of: cameraModel.photo) {
            displayedPhoto = cameraModel.photo.image
            photoSource = .camera
            //            cameraModel.photo = nil
        }
    }
    
    var photoPicker: some View {
        PhotosPicker(selection: $selectedPhotoFromPicker, matching: .images) {
            if let image = mostRecentImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 60, height: 60, alignment: .center)
                    .foregroundColor(.black)
            }
        }
        .onAppear {
            fetchMostRecentImage()
        }
        .onChange(of: selectedPhotoFromPicker) {
            Task {
                if let data = try? await selectedPhotoFromPicker?.loadTransferable(type: Data.self)
                {
                    displayedPhoto = UIImage(data: data)
                    photoSource = .library
                    selectedPhotoFromPicker = nil
                }
            }
        }
    }
    
    var flipCameraButton: some View {
        Button(action: {
            cameraModel.flipCamera()
        }, label: {
            Circle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(width: 60, height: 60, alignment: .center)
                .overlay(
                    Image(systemName: "camera.rotate.fill")
                        .foregroundColor(.white))
        })
    }
    var body: some View {
        ZStack {
            GeometryReader { reader in
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    HStack {
                        Button(action: {
                            cameraModel.switchFlash()
                        }, label: {
                            Image(systemName: cameraModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                                .font(.system(size: 20, weight: .medium, design: .default))
                        })
                        .accentColor(cameraModel.isFlashOn ? .yellow : .white)
                        
                        CameraPreview(session: cameraModel.session, currentOrientation: $cameraModel.currentOrientation)
                            .onRotate { newOrientation in
                                cameraModel.updateOrientation(newOrientation)
                            }
                            .gesture(
                                DragGesture().onChanged({ (val) in
                                    // Only accept vertical drag
                                    if abs(val.translation.height) > abs(val.translation.width) {
                                        // Get the percentage of vertical screen space covered by drag
                                        let percentage: CGFloat = -(val.translation.height / reader.size.height)
                                        // Calculate new zoom factor
                                        let calc = currentZoomFactor + percentage
                                        // Limit zoom factor to a maximum of 5x and a minimum of 1x
                                        let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                        // Store the newly calculated zoom factor
                                        currentZoomFactor = zoomFactor
                                        // Sets the zoom factor to the capture device session
                                        cameraModel.zoom(with: zoomFactor)
                                    }
                                })
                            )
                            .onAppear {
                                cameraModel.configure()
                            }
                            .alert(isPresented: $cameraModel.showAlertError, content: {
                                Alert(title: Text(cameraModel.alertError.title), message: Text(cameraModel.alertError.message), dismissButton: .default(Text(cameraModel.alertError.primaryButtonTitle), action: {
                                    cameraModel.alertError.primaryAction?()
                                }))
                            })
                            .overlay(
                                Group {
                                    if cameraModel.willCapturePhoto {
                                        Color.black
                                    }
                                }
                                    .animation(.easeInOut, value: cameraModel.willCapturePhoto)
                            )
                        VStack {
                            flipCameraButton
                            Spacer()
                            captureButton
                            Spacer()
                            photoPicker
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        //        .onAppear {
        //            cameraModel.configure()
        //            cameraModel.startCameraSession()
        //        }
        //        .onDisappear {
        //            cameraModel.stopCameraSession()
        //        }
        .padding(.top)
        .sheet(isPresented: $isShowingPhotoDisplay) {
            PhotoDisplayView(navigationVM: navigationVM, photo: $displayedPhoto, source: $photoSource, retakeAction: {
                isShowingPhotoDisplay = false
            }, cameraModel: cameraModel, ballClassificationModel: ballClassificationModel, isShowingPhotoDisplay: $isShowingPhotoDisplay)
            
        }
        .onChange(of: displayedPhoto) {
            if displayedPhoto != nil {
                isShowingPhotoDisplay = true
            }
        }
        .navigationBarBackButtonHidden()
        .overlay(alignment: .topLeading) {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(Circle())
            })
            .padding(.top,16)
            .offset(x: -32)
        }
        
        .overlay(alignment: .bottomLeading) {
            Button(action: {
                isShowingCameraGuideline.toggle()
            }, label: {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(Circle())
            })
            .padding(.top,16)
            .offset(x: -32)
        }
        .sheet(isPresented: $isShowingCameraGuideline) {
            CameraGuidelineView()
        }
        .onAppear {
            if !isShowingCameraGuideline {
                isShowingCameraGuideline.toggle()
            }
        }
        //        .border(.red)
        //        .ignoresSafeArea()
    }
    
    func fetchMostRecentImage() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if let asset = fetchResult.firstObject {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: option) { image, _ in
                self.mostRecentImage = image
            }
        }
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}
