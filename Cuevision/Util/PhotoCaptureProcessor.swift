//
//  PhotoCaptureProcessor.swift
//  abseil
//
//  Created by Rolando Rodriguez on 10/15/20.
//

import Foundation
import Photos
import UIKit

class PhotoCaptureProcessor: NSObject {
    
    lazy var context = CIContext()
    
    private let orientation: UIDeviceOrientation
    
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
    
    private let willCapturePhotoAnimation: () -> Void
    
    private let completionHandler: (PhotoCaptureProcessor) -> Void
    
    private let photoProcessingHandler: (Bool) -> Void
    
    //    The actual captured photo's data
    var photoData: Data?
    //    The maximum time lapse before telling UI to show a spinner
    private var maxPhotoProcessingTime: CMTime?
    
    //    Init takes multiple closures to be called in each step of the photco capture process
    init(with requestedPhotoSettings: AVCapturePhotoSettings, orientation: UIDeviceOrientation,
         willCapturePhotoAnimation: @escaping () -> Void, completionHandler: @escaping (PhotoCaptureProcessor) -> Void, photoProcessingHandler: @escaping (Bool) -> Void) {
        
        self.requestedPhotoSettings = requestedPhotoSettings
        self.willCapturePhotoAnimation = willCapturePhotoAnimation
        self.completionHandler = completionHandler
        self.photoProcessingHandler = photoProcessingHandler
        self.orientation = orientation
    }
}

extension PhotoCaptureProcessor: AVCapturePhotoCaptureDelegate {
    
    // This extension adopts AVCapturePhotoCaptureDelegate protocol methods.
    
    /// - Tag: WillBeginCapture
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        maxPhotoProcessingTime = resolvedSettings.photoProcessingTimeRange.start + resolvedSettings.photoProcessingTimeRange.duration
    }
    
    /// - Tag: WillCapturePhoto
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        DispatchQueue.main.async {
            self.willCapturePhotoAnimation()
        }
        
        guard let maxPhotoProcessingTime = maxPhotoProcessingTime else {
            return
        }
        
        // Show a spinner if processing time exceeds one second.
        let oneSecond = CMTime(seconds: 2, preferredTimescale: 1)
        if maxPhotoProcessingTime > oneSecond {
            DispatchQueue.main.async {
                self.photoProcessingHandler(true)
            }
        }
    }
    
    /// - Tag: DidFinishProcessingPhoto
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        DispatchQueue.main.async {
            self.photoProcessingHandler(false)
        }
        
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            
            let photo = photo.fileDataRepresentation()
            // Adjust image orientation
            if let photo = photo, let image = UIImage(data: photo) {
                let adjustedImage = self.adjustedImage(image, for: self.orientation)
                let resizedImage = self.resizeImage(image: adjustedImage, targetSize: CGSize(width: 1920, height: 1440))
                let croppedImage = self.cropImage(resizedImage, toRect: CGRect(x: 0, y: 0, width: 1920, height: 1080), viewWidth: 1920, viewHeight: 1080)
                self.photoData = croppedImage?.jpegData(compressionQuality: 1.0)
            }
        }
    }
    
    //        MARK: Saves capture to photo library
    func saveToPhotoLibrary(_ photoData: Data) {
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    let options = PHAssetResourceCreationOptions()
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    options.uniformTypeIdentifier = self.requestedPhotoSettings.processedFileType.map { $0.rawValue }
                    creationRequest.addResource(with: .photo, data: photoData, options: options)
                    
                    
                }, completionHandler: { _, error in
                    if let error = error {
                        print("Error occurred while saving photo to photo library: \(error)")
                    }
                    
                    DispatchQueue.main.async {
                        self.completionHandler(self)
                    }
                }
                )
            } else {
                DispatchQueue.main.async {
                    self.completionHandler(self)
                }
            }
        }
    }
    
    /// - Tag: DidFinishCapture
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            DispatchQueue.main.async {
                self.completionHandler(self)
            }
            return
        } else {
            guard let data  = photoData else {
                DispatchQueue.main.async {
                    self.completionHandler(self)
                }
                return
            }
            
            self.saveToPhotoLibrary(data)
        }
    }
    
    
    private func adjustedImage(_ image: UIImage, for orientation: UIDeviceOrientation) -> UIImage {
        let imageOrientation: UIImage.Orientation
        
        switch orientation {
        case .portraitUpsideDown:
            imageOrientation = .left
        case .landscapeLeft:
            imageOrientation = .up
        case .landscapeRight:
            imageOrientation = .down
        default:
            imageOrientation = .right
        }
        
        if image.imageOrientation == imageOrientation {
            return image
        }
        
        let adjustedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: imageOrientation)
        
        return adjustedImage
    }
    
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)
        
        
        // Scale cropRect to handle images larger than shown-on-screen size
        //        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
        //                              y:cropRect.origin.y * imageViewScale,
        //                              width:cropRect.size.width * imageViewScale,
        //                              height:cropRect.size.height * imageViewScale)
        
        
        // Perform cropping in Core Graphics
        
        let cropZone = CGRect(x:0, y:180 ,width:1920,height:1080)
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
        else {
            return nil
        }
        
        
        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
