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
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .imageScale(.large)
                .overlay(
                    GeometryReader { geometry in
                        ForEach(detectedObjects, id: \.label) { object in
                            let boundingBox = CGRect(
                                x: object.boundingBox.minX * geometry.size.width,
                                y: object.boundingBox.minY * geometry.size.height,
                                width: object.boundingBox.width * geometry.size.width,
                                height: object.boundingBox.height * geometry.size.height
                            )

                            // Draw the bounding box
                            Rectangle()
                                .path(in: boundingBox)
                                .stroke(Color.red, lineWidth: 2.0)

                            // Display the label
                            Text("\(object.label) (\(String(format: "%.2f", object.confidence)))")
                                .font(.caption)
                                .padding(2)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(3)
                                .position(x: boundingBox.midX, y: boundingBox.minY - 10) // Above the bounding box

                            // Display the coordinates
                            let xCoordinate = boundingBox.minX + (boundingBox.width / 2)
                            let yCoordinate = boundingBox.minY + (boundingBox.height / 2)
                            VStack{
                                Text("X: \(String(format: "%.2f", xCoordinate))")
                                    .font(.caption2)

                                Text("Y: \(String(format: "%.2f", yCoordinate))")
                                    .font(.caption2)
                            }
                            .padding(4)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .position(x: xCoordinate, y: yCoordinate + 15)
                        }
                    }
                )
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden()
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
                print(results.debugDescription)
            }
        }
    }
}
