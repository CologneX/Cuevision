//
//  ContentView.swift
//  billihelper
//
//  Created by Kyrell Leano Siauw on 12/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var processedImage: UIImage? = nil
    @State private var showFullScreenImage = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                CameraView(processedImage: $processedImage)
                    .edgesIgnoringSafeArea(.all)
                
                Button(action: {
                    // Trigger photo capture
                    NotificationCenter.default.post(name: NSNotification.Name("TakePhoto"), object: nil)
                }) {
                    Label {
                    } icon: {
                        ZStack {
                            Circle()
                                .strokeBorder(.white, lineWidth: 3)
                                .frame(width: 62, height: 62)
                            Circle()
                                .fill(.white)
                                .frame(width: 50, height: 50)
                        }
                    }
                }
                .padding(.bottom, 20)
                
                if processedImage != nil {
                    NavigationLink(
                        destination:
                            
                            FullScreenImageView(processedImage: $processedImage),
                        isActive: $showFullScreenImage
                    ) {
                        EmptyView()
                    }
                    .onAppear {
                        showFullScreenImage = true
                    }
                }
            }
        }
    }
}
