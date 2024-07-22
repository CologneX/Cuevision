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
        
    @Binding var isShowingPhotoDisplay: Bool

    
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
        .overlay(alignment: .topLeading){
            Button(action: {
                isShowingPhotoDisplay = false
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(Circle())
            })
            .padding(12)
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
