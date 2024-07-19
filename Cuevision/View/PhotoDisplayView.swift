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
    @ObservedObject var ballClassificationModel: BilliardBallClassifier
    @Binding var isShowingPhotoDisplay: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showGameAnalysis = false

    
    var body: some View {
        NavigationStack{
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
        }
        .navigationBarBackButtonHidden()
//        .overlay(alignment: .topLeading) {
//            Button(action: {
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                Image(systemName: "chevron.left")
//                    .background(.thinMaterial)
//                    .clipShape(Circle())
//            }
//            .padding(16)
//
//        }
        .overlay(alignment: .topLeading){
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(Circle())
            })
            .padding(12)
        }
        .sheet(isPresented: $showGameAnalysis) {
            GameAnalysisView(image: photo, model: cameraModel,ballClassificationModel: ballClassificationModel, isShowingPhotoDisplay: $isShowingPhotoDisplay)
        }
    }
}
