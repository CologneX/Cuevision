//
//  ContentView.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 12/07/24.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var cameraViewModel = CameraViewModel()
    @StateObject private var photoLibraryViewModel = PhotoLibraryViewModel()
    @State private var isNavigationActive: Bool = false
    @State private var isPhotoLibraryActive: Bool = false
    var body: some View {
        NavigationStack {
            HStack {
                CameraViewController(CameraViewModel: cameraViewModel)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        cameraViewModel.startRunning()
                    }
                    .onDisappear {
                        cameraViewModel.stopRunning()
                    }
                VStack{
                    Button(action: {
                        // Show photo picker
                        photoLibraryViewModel.showPhotoPicker()
                    }) {
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding()
                    }
                    Spacer()
                    Button(action: {
                        // Trigger photo capture
                        cameraViewModel.takePhoto()
                    }) {
                        Label {
                        } icon: {
                            ZStack {
                                Circle()
                                    .strokeBorder(.white, lineWidth: 3)
                                    .frame(width: 62, height: 62)
                                Circle()
                                    .fill(.white)
                                    .frame(width: 50, height: 50)
                            }
                        }
                    }
                    Spacer()
                }
                .onChange(of: cameraViewModel.processedImage) {
                    if cameraViewModel.processedImage != nil {
                        isNavigationActive = true
                    }
                }
                .onChange(of: photoLibraryViewModel.selectedImage) {
                    if photoLibraryViewModel.selectedImage != nil {
                        isPhotoLibraryActive = true
                    }
                }
                .navigationDestination(isPresented: $isNavigationActive) {
                    FullScreenImageView(processedImage: $cameraViewModel.processedImage, isNavigationActive: $isNavigationActive)
                }
                .navigationDestination(isPresented: $isPhotoLibraryActive) {
                    if let selectedImage = photoLibraryViewModel.selectedImage {
                        FullScreenImageView(processedImage: .constant(selectedImage), isNavigationActive: $isPhotoLibraryActive)
                    }
                }
            }
        }
    }
}
