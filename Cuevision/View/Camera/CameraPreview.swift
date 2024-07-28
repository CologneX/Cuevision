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
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
//        let screenRect = CGRect(x: 0, y: 0, width: 1024, height: 768)
//        let aspectRatio = CGSize(width: 16, height: 9)
//        view.videoPreviewLayer.frame = AVMakeRect(aspectRatio: aspectRatio, insideRect: screenRect)
//        view.videoPreviewLayer.connection?.videoRotationAngle = 0
//        view.videoPreviewLayer.connection?.videoOrientation = .landscapeLeft
        view.videoPreviewLayer.session = session
        updateOrientation(view: view)
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        updateOrientation(view: uiView)
//        uiView.videoPreviewLayer.frame = calculatePreviewLayerFrame(for: uiView)
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

private func calculatePreviewLayerFrame(for view: UIView) -> CGRect {
    let viewWidth = view.bounds.width
    let viewHeight = view.bounds.height
    let desiredAspectRatio: CGFloat = 16.0 / 9.0
    
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    
    if viewWidth / viewHeight > desiredAspectRatio {
        // View is wider than 16:9, so height will determine the frame size
        frameHeight = viewHeight
        frameWidth = frameHeight * desiredAspectRatio
    } else {
        // View is taller than 16:9, so width will determine the frame size
        frameWidth = viewWidth
        frameHeight = frameWidth / desiredAspectRatio
    }
    
    let x = (viewWidth - frameWidth) / 2
    let y = (viewHeight - frameHeight) / 2
    
    return CGRect(x: x, y: y, width: frameWidth, height: frameHeight)
}
