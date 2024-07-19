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
        updateOrientation(view: view)
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        updateOrientation(view: uiView)
    }
    
    private func updateOrientation(view: VideoPreviewView) {
        switch currentOrientation {
        case .landscapeLeft:
            view.videoPreviewLayer.connection?.videoOrientation = .landscapeRight
        case .landscapeRight:
            view.videoPreviewLayer.connection?.videoOrientation = .landscapeLeft
//        case .portrait:
//            view.videoPreviewLayer.connection?.videoOrientation = .portrait
//        case .portraitUpsideDown:
//            view.videoPreviewLayer.connection?.videoOrientation = .portraitUpsideDown
        default:
            view.videoPreviewLayer.connection?.videoOrientation = .landscapeRight
        }
    }
}
