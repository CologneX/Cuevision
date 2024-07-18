//
//  PhotoLibraryView.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 16/07/24.
//

import SwiftUI

struct ConfirmationView: View {
    @Binding var image: UIImage?
    var onConfirm: () -> Void
    var onRetake: () -> Void
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            HStack {
                Button("Retake") {
                    onRetake()
                }
                Spacer()
                Button("Use Photo") {
                    onConfirm()
                }
            }
            .padding()
        }
    }
}
