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

    var body: some View {
        NavigationStack{
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)

                List(model.classificationResults, id: \.self) { result in
                    HStack {
                        Text(result.identifier)
                        Spacer()
                        Text(String(format: "%.2f%%", result.confidence * 100))
                    }
                }
            }
        }
        .onAppear {
            model.classifyImage(image)
        }
    }
}
