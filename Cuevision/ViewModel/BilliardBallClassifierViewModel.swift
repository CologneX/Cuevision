//
//  BilliardBallClassifier.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 19/07/24.
//

import Foundation
import Vision
import Photos
import UIKit

struct DetectedObject {
    let label: String
    let confidence: Float
    let boundingBox: CGRect
}

class BilliardBallClassifier: ObservableObject {
    private var model: VNCoreMLModel
    
    init() {
        guard let model = try? VNCoreMLModel(for: YOLOPool().model) else {
            fatalError("Failed to create VNCoreMLModel")
        }
        self.model = model
    }
    
    func classify(image: UIImage, completion: @escaping ([DetectedObject]) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create CIImage from UIImage")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                print("Error in classification: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let results = request.results else {
                print("No results found")
                completion([])
                return
            }
            
            if let objectDetections = results as? [VNRecognizedObjectObservation] {
                let detectedObjects = objectDetections.map { observation -> DetectedObject in
                    let bestLabel = observation.labels.first!
                    return DetectedObject(label: bestLabel.identifier, confidence: bestLabel.confidence, boundingBox: observation.boundingBox)
                }
                completion(detectedObjects)
            } else {
                fatalError("Unexpected result type from VNCoreMLRequest")
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform classification: \(error.localizedDescription)")
            }
        }
    }
}
