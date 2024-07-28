//
//  PhotoDisplayView.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 19/07/24.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct PhotoDisplayView: View {
    @Binding var photo: UIImage?
    
    @Binding var source: PhotoSource?
    let retakeAction: () -> Void
    @ObservedObject var cameraModel: CameraModel
    @ObservedObject var ballClassificationModel: BilliardBallClassifier
    @Binding var isShowingPhotoDisplay: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showGameAnalysis = false
    @State var scaleBetweenImages: Double = 0.0
    @State private var warpedImage: UIImage?
    @State private var isProcessingImage: Bool = true
    
    @State private var rectanglePoints: [CGPoint] = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 0)
    ]
    var imagePoint: some View {
        ZStack {
            if isProcessingImage {
                GroupBox{
                    HStack{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("Processing Image")
                            .font(.body)
                    }
                    .padding()
                }
                .background(.thinMaterial)
                .cornerRadius(10)
            } else {
                if let image = photo {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .overlay(
                            GeometryReader { geometry in
                                Path { path in
                                    path.move(to: rectanglePoints[0])
                                    for point in rectanglePoints.dropFirst() {
                                        path.addLine(to: point)
                                    }
                                    path.closeSubpath()
                                }
                                .stroke(.white, lineWidth: 2)
                                .onAppear {
                                    scaleBetweenImages =  Double(image.size.height) / Double(geometry.size.height)
                                    rectanglePoints = [
                                        CGPoint(x: geometry.size.width * 0.1, y: geometry.size.height * 0.1),
                                        CGPoint(x: geometry.size.width * 0.9, y: geometry.size.height * 0.1),
                                        CGPoint(x: geometry.size.width * 0.9, y: geometry.size.height * 0.9),
                                        CGPoint(x:  geometry.size.width * 0.1, y: geometry.size.height * 0.9)
                                    ]
                                }
                                ForEach(0..<4) { index in
                                    Circle()
                                        .fill(Color(hex: 0x428365))
                                        .frame(width: 20, height: 20)
                                        .position(rectanglePoints[index])
                                        .gesture(
                                            DragGesture()
                                                .onChanged { value in
                                                    // restraint the point within the image
                                                    let x = min(max(value.location.x, 0), geometry.size.width)
                                                    let y = min(max(value.location.y, 0), geometry.size.height)
                                                    rectanglePoints[index] = CGPoint(x: x, y: y)
                                                }
                                        )
                                    Text("\(index + 1)")
                                        .position(rectanglePoints[index])
                                        .foregroundStyle(.white)
                                }
                            }
                        )
                        .padding(.top )
                }
            }
        }
//        .ignoresSafeArea()
    }
    
    var body: some View {
        NavigationStack{
            imagePoint
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    isProcessingImage = true
                    processImage()
                }
                .onChange(of: warpedImage){
                    if warpedImage != nil {
                        showGameAnalysis = true
                    }
                }
                .navigationDestination(isPresented: $showGameAnalysis) {
                    DiamondMainView(image: $warpedImage, model: cameraModel, ballClassificationModel: ballClassificationModel, isShowingPhotoDisplay: $isShowingPhotoDisplay)
                }
                .overlay(alignment: .topTrailing){
                    ZStack{
                        if source == .camera {
                            HStack {
                                Button("Use Photo") {
                                    applyWarpPerspective()
                                }
                            }
                        } else {
                            Button("Analyze Photo") {
                                applyWarpPerspective()
                            }
                        }
                    }
                    .padding(16)
                }
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
                    .padding(16)
                }
                .ignoresSafeArea(.all, edges: [.horizontal])
        }
        .navigationBarBackButtonHidden()
    }
    
    private func applyWarpPerspective() {
        guard let inputImage = photo,
              rectanglePoints.count == 4 else { return }
        
        let topLeft = rectanglePoints[0]
        let topRight = rectanglePoints[1]
        let bottomRight = rectanglePoints[2]
        let bottomLeft = rectanglePoints[3]
        
        let topLeftPoint = CGPoint(x: topLeft.x * scaleBetweenImages, y: inputImage.size.height - (topLeft.y * scaleBetweenImages))
        let topRightPoint = CGPoint(x: topRight.x * scaleBetweenImages, y: inputImage.size.height - (topRight.y * scaleBetweenImages))
        let bottomRightPoint = CGPoint(x: bottomRight.x * scaleBetweenImages, y: inputImage.size.height - (bottomRight.y * scaleBetweenImages))
        let bottomLeftPoint = CGPoint(x: bottomLeft.x * scaleBetweenImages, y: inputImage.size.height - (bottomLeft.y * scaleBetweenImages))
        
        let perspectiveTranformation = CIFilter.perspectiveCorrection()
        perspectiveTranformation.inputImage = CIImage(image: inputImage)
        perspectiveTranformation.topLeft = topLeftPoint
        perspectiveTranformation.topRight = topRightPoint
        perspectiveTranformation.bottomRight = bottomRightPoint
        perspectiveTranformation.bottomLeft = bottomLeftPoint
        
        if let outputImage = perspectiveTranformation.outputImage ,
           let cgImg = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            warpedImage = UIImage(cgImage: cgImg)
        }
    }
    
    private func isImage16to9(_ image: UIImage) -> Bool {
        let aspectRatio = image.size.width / image.size.height
        let targetRatio: CGFloat = 16.0 / 9.0
        
        // Allow for a small margin of error (0.01)
        return abs(aspectRatio - targetRatio) < 0.01
    }
    
    private func aspectRatioProcessor(_ image: UIImage, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Check if the image is 16:9
            if !isImage16to9(image) {
                // Crop the image to 16:9
                let targetWidth = image.size.height * 16 / 9
                let targetHeight = image.size.width * 9 / 16
                let targetRect = CGRect(x: (image.size.width - targetWidth) / 2, y: (image.size.height - targetHeight) / 2, width: targetWidth, height: targetHeight)
                if let cgImage = image.cgImage?.cropping(to: targetRect) {
                    DispatchQueue.main.async {
                        photo = UIImage(cgImage: cgImage)
                        completion()
                    }
                } else {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    private func processImage() {
        guard let image = photo else { return }
        aspectRatioProcessor(image) {
            withAnimation {
                isProcessingImage = false
            }
        }
    }
}
