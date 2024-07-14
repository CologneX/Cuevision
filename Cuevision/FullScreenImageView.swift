//
//  FullScreenImageView.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 13/07/24.
//

import SwiftUI

struct FullScreenImageView: View {
    @Binding var processedImage: UIImage?

    var body: some View {
       
            if let image = processedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
            }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}
