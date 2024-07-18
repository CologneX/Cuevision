//
//  FullScreenImageView.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 13/07/24.
//

import SwiftUI

struct FinalDisplayView: View {
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
