//
//  FullScreenImageView.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 13/07/24.
//

import SwiftUI

struct FullScreenImageView: View {
    @Binding var processedImage: UIImage?
    @Binding var isNavigationActive: Bool
    @State private var isButtonVisible: Bool = true
    @State private var timer: Timer?

    var body: some View {
        NavigationStack {
            VStack {
                if let image = processedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text("No image available")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .overlay(
            VStack {
                HStack {
                    if isButtonVisible {
                        Button(action: {
                            isNavigationActive = false
                        }) {
                            Image(systemName: "chevron.left")
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                    Spacer()
                }
                Spacer()
            }
        )
        .onAppear {
            startTimer()
        }
        .onTapGesture {
            resetTimer()
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            withAnimation {
                isButtonVisible = false
            }
        }
    }

    private func resetTimer() {
        withAnimation {
            isButtonVisible = true
        }
        startTimer()
    }
}
