//
//  CameraViewController.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 12/07/24.
//

import AVFoundation
import SwiftUI

struct CameraViewController: UIViewControllerRepresentable {
    @ObservedObject var CameraViewModel: CameraViewModel
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        setupLivePreview(on: viewController)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    private func setupLivePreview(on viewController: UIViewController) {
        let previewLayer = AVCaptureVideoPreviewLayer(session: CameraViewModel.captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = viewController.view.frame
        previewLayer.connection?.videoOrientation = .landscapeRight
        viewController.view.layer.addSublayer(previewLayer)
        
        CameraViewModel.startRunning()
    }
}

