//
//  GameAnalysisView.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 19/07/24.
//

import SwiftUI

struct GameAnalysisView: View {
    let image: UIImage
    
    @ObservedObject var model: CameraModel
    
    @ObservedObject var ballClassificationModel: BilliardBallClassifier
    
    @State var detectedObjects: [DetectedObject] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    let imageSize = CGSize(width: image.size.width, height: image.size.height)
                    let scale = min(geometry.size.width / imageSize.width, geometry.size.height / imageSize.height)
                    let scaledSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
                    
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: scaledSize.width, height: scaledSize.height)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    ForEach(detectedObjects, id: \.label) { object in
                        BoundingBoxView(boundingBox: object.boundingBox, label: object.label, confidence: object.confidence, imageSize: imageSize)
                    }
                }
            }
        }
        .onAppear {
            classifyImage()
        }
    }
    
    private func classifyImage() {
        ballClassificationModel.classify(image: image) { [self] results in
            DispatchQueue.main.async {
                self.detectedObjects = results
                print(results.description)
            }
        }
    }
}

struct BoundingBoxView: View {
    let boundingBox: CGRect
    let label: String
    let confidence: Float
    let imageSize: CGSize
    
    var body: some View {
        GeometryReader { geometry in
            let scale = min(geometry.size.width / imageSize.width, geometry.size.height / imageSize.height)
            let offsetX = (geometry.size.width - imageSize.width * scale) / 2
            let offsetY = (geometry.size.height - imageSize.height * scale) / 2
            
            let frame = CGRect(
                x: boundingBox.minX * imageSize.width * scale + offsetX,
                y: (1 - boundingBox.maxY) * imageSize.height * scale + offsetY,
                width: boundingBox.width * imageSize.width * scale,
                height: boundingBox.height * imageSize.height * scale
            )
            
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .path(in: frame)
                    .stroke(Color.red, lineWidth: 2)
                
                Text("\(label) (\(String(format: "%.2f", confidence)))")
                    .font(.caption)
                    .padding(2)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(3)
                    .offset(x: frame.minX, y: frame.minY)
            }
        }
    }
}
