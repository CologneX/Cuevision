//
//  CameraViewModel.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 16/07/24.
//

import SwiftUI
import AVFoundation

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var processedImage: UIImage? = nil
    
    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    
    override init() {
        super.init()
        setupCamera()
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: backCamera) else {
            return
        }
        
        photoOutput = AVCapturePhotoOutput()
        
        if captureSession.canAddInput(input) && captureSession.canAddOutput(photoOutput) {
            captureSession.addInput(input)
            captureSession.addOutput(photoOutput)
        } else {
            return
        }
    }
    
    func startRunning() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func stopRunning() {
        captureSession.stopRunning()
    }
    
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func processImage(_ image: UIImage) -> UIImage {
        return applyPerspectiveCorrection(to: image) ?? image
    }
    
    func applyPerspectiveCorrection(to image: UIImage) -> UIImage? {
        /// Uncomment code guard kalo mau transform imagenya
        
        //        guard let ciImage = CIImage(image: image) else {
        //            print("Failed to create CIImage from UIImage.")
        //            return nil
        //        }
        return image
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        
        if let image = UIImage(data: imageData) {
            DispatchQueue.main.async {
                self.processedImage = self.processImage(image)
            }
        }
    }
}

class CameraUIViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
}
