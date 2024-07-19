//
//  PhotoDisplayView.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 19/07/24.
//

import Foundation
import SwiftUI

struct PhotoDisplayView: View {
    let photo: UIImage
    
    let source: PhotoSource
    
    let retakeAction: () -> Void
    
    @ObservedObject var cameraModel: CameraModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showGameAnalysis = false
    
    @ObservedObject var ballClassificationModel: BilliardBallClassifier

    var body: some View {
        VStack {
            Image(uiImage: photo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            if source == .camera {
                HStack {
                    Button("Retake") {
                        retakeAction()
                    }
                    Button("Use Photo") {
                        showGameAnalysis = true
                    }
                }
            } else {
                Button("Analyze Photo") {
                    showGameAnalysis = true
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .overlay(alignment: .topLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                }
                .padding(16)
                .background(.thinMaterial)
                .clipShape(Circle())
            }
        }
        .sheet(isPresented: $showGameAnalysis) {
            GameAnalysisView(image: photo, model: cameraModel,ballClassificationModel: ballClassificationModel)
        }
    }
}
