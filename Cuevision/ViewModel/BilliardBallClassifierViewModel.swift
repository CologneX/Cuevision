//
//  BilliardBallClassifier.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 19/07/24.
//

import Vision
import UIKit

struct DetectedObject: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    var boundingBox: CGRect
    var position: CGPoint
}

class BilliardBallClassifier: ObservableObject {
    private var model: VNCoreMLModel
    
    init() {
        guard let model = try? VNCoreMLModel(for: v8m2().model) else {
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
            
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("No results found")
                completion([])
                return
            }
            
            let detectedObjects = results.map { observation -> DetectedObject in
                let bestLabel = observation.labels.first!
                let position = CGPoint(x: observation.boundingBox.midX, y: observation.boundingBox.midY)
                return DetectedObject(label: bestLabel.identifier,
                                      confidence: bestLabel.confidence,
                                      boundingBox: observation.boundingBox,
                                      position: position)
            }
            
            completion(detectedObjects)
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .downMirrored)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform classification: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}
