//
//  CameraView.swift
//  billihelper
//
//  Created by Kyrell Leano Siauw on 12/07/24.
//

import SwiftUI
import AVFoundation
import CoreImage
import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var processedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        context.coordinator.setupCamera(viewController: viewController)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraView
        var captureSession: AVCaptureSession!
        var photoOutput: AVCapturePhotoOutput!
        
        init(_ parent: CameraView) {
            self.parent = parent
            super.init()
            NotificationCenter.default.addObserver(self, selector: #selector(takePhoto), name: NSNotification.Name("TakePhoto"), object: nil)
        }
        
        func setupCamera(viewController: UIViewController) {
            captureSession = AVCaptureSession()
            captureSession.sessionPreset = .photo
            
            guard let backCamera = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: backCamera) else {
                print("Failed to access the back camera.")
                return
            }
            
            photoOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(photoOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(photoOutput)
                setupLivePreview(on: viewController)
            } else {
                print("Failed to add input or output to capture session.")
            }
        }
        
        func setupLivePreview(on viewController: UIViewController) {
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.videoOrientation = .portrait
            previewLayer.frame = viewController.view.frame
            viewController.view.layer.addSublayer(previewLayer)
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
        
        @objc func takePhoto() {
            print("Taking photo...")
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            guard error == nil else {
                print("Error capturing photo: \(error!.localizedDescription)")
                return
            }
            
            guard let imageData = photo.fileDataRepresentation() else {
                print("Failed to get image data from photo.")
                return
            }
            
            if let image = UIImage(data: imageData) {
                print("Photo captured successfully.")
                parent.processedImage = parent.processImage(image)
            } else {
                print("Failed to create UIImage from image data.")
            }
        }
    }
    func processImage(_ image: UIImage) -> UIImage {
        return applyPerspectiveCorrection(to: image) ?? image
    }
    
    func applyPerspectiveCorrection(to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            print("Failed to create CIImage from UIImage.")
            return nil
        }
        
        // Define the coordinates for the corners of the billiards table in the image
        // These values should be determined dynamically, but for simplicity, we use fixed values here
        let topLeft = CGPoint(x: 100, y: 100)
        let topRight = CGPoint(x: 400, y: 100)
        let bottomLeft = CGPoint(x: 100, y: 400)
        let bottomRight = CGPoint(x: 400, y: 400)
        
        let filter = CIFilter(name: "CIPerspectiveCorrection")
        filter?.setValue(CIVector(cgPoint: topLeft), forKey: "inputTopLeft")
        filter?.setValue(CIVector(cgPoint: topRight), forKey: "inputTopRight")
        filter?.setValue(CIVector(cgPoint: bottomLeft), forKey: "inputBottomLeft")
        filter?.setValue(CIVector(cgPoint: bottomRight), forKey: "inputBottomRight")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let outputImage = filter?.outputImage,
           let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        } else {
            print("Failed to apply perspective correction.")
        }
        
        return nil
    }
}
