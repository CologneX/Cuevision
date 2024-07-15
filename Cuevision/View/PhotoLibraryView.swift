//
//  PhotoLibraryView.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 16/07/24.
//

import SwiftUI

struct PhotoLibraryView: View {
    let images: [UIImage]

    var body: some View {
        ScrollView {
            VStack {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
            }
        }
        .navigationTitle("Photo Library")
    }
}
