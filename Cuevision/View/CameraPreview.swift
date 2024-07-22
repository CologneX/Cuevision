//
//  CameraPreview.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 18/07/24.
//

import SwiftUI
import AVFoundation


struct CameraPreview: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
    @Binding var currentOrientation: UIDeviceOrientation
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.session = session
//        updateOrientation(view: view)
        var rotationCoordinator = AVCaptureDevice.RotationCoordinator(device: <#T##AVCaptureDevice#>, previewLayer: view.videoPreviewLayer)
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        updateOrientation(view: uiView)
    }
    
    private func updateOrientation(view: VideoPreviewView) {
        switch currentOrientation {
        case .landscapeLeft:
            view.videoPreviewLayer.connection?.videoRotationAngle = 0
        case .landscapeRight:
            view.videoPreviewLayer.connection?.videoRotationAngle = 180
        default:
            view.videoPreviewLayer.connection?.videoRotationAngle = 0
        }
    }
}
