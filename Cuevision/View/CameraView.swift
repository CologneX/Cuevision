//
//  CameraView.swift
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
    @StateObject var model = CameraModel()
    
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var selectedImageData: Data?
    
    @State private var currentZoomFactor: CGFloat = 1.0
    
    @State private var deviceOrientation: UIDeviceOrientation = .unknown
    
    @State private var isShowingPhotoDisplay = false
    
    @State private var displayedImage: UIImage?
    
    @State private var photoSource: PhotoSource = .camera
    
    @State private var mostRecentImage: UIImage?

    var captureButton: some View {
        Button(action: {
            model.capturePhoto()
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
        .onChange(of: model.photo) { newPhoto in
            if let photo = newPhoto, let uiImage = photo.image {
                displayedImage = uiImage
                photoSource = .camera
                isShowingPhotoDisplay = true
            }
        }
    }
    
    var photoPicker: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
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
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                    if let uiImage = UIImage(data: data) {
                        displayedImage = uiImage
                        photoSource = .library
                        isShowingPhotoDisplay = true
                    }
                }
            }
        }
    }
    
    
    var flipCameraButton: some View {
        Button(action: {
            model.flipCamera()
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
        GeometryReader { reader in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                HStack {
                    Button(action: {
                        model.switchFlash()
                    }, label: {
                        Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 20, weight: .medium, design: .default))
                    })
                    .accentColor(model.isFlashOn ? .yellow : .white)
                    
                    CameraPreview(session: model.session, currentOrientation: $model.currentOrientation)
                        .onRotate { newOrientation in
                            model.updateOrientation(newOrientation)
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
                                    model.zoom(with: zoomFactor)
                                }
                            })
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            model.configure()
                        }
                        .alert(isPresented: $model.showAlertError, content: {
                            Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                                model.alertError.primaryAction?()
                            }))
                        })
                        .overlay(
                            Group {
                                if model.willCapturePhoto {
                                    Color.black
                                }
                            }
                                .animation(.easeInOut, value: model.willCapturePhoto)
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
            .sheet(isPresented: $isShowingPhotoDisplay) {
                if let image = displayedImage {
                    NavigationView {
                        PhotoDisplayView(photo: image, source: photoSource, retakeAction: {
                            isShowingPhotoDisplay = false
                        }, model: model)
                    }
                }
            }
        }
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

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
