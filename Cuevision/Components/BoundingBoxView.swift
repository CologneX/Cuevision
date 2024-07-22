//
//  BoundingBoxView.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 22/07/24.
//

import SwiftUI

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
