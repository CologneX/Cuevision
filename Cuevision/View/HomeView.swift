//
//  HomeView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 16/07/24.
//

import SwiftUI

struct HomeView: View {
    @State private var navigationVM = NavigationViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationVM.path) {
            ZStack{
                Image("HomeBG")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                HStack{
                    Text("\"Learn How To Aim Better Using Diamond System\"")
                        .font(Font.custom("SFPro-ExpandedBold", size: 20.0))
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    VStack{
                        Button {
                            navigationVM.goToNextPage(screenName: "Camera View")
                        } label: {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color(hex: 0x428365))
                                .fontWeight(.semibold)
                                .padding(.horizontal, 60)
                                .padding(.vertical, 20)
                                .background(Color.white)
                                .cornerRadius(50)
                        }
                        
                        Button {
                            navigationVM.goToNextPage(screenName: "Billiard Tips")
                        } label: {
                            Text("Billiard Tips")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(Color.white)
                                .foregroundColor(Color(hex: 0x428365))
                                .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.horizontal, 48)
            }
            .navigationDestination(for: String.self, destination: { path in
                if path == "Billiard Tips" {
                    InformationView(navigationVM: navigationVM)
                } else {
                    CameraView()
                }
            })
        }
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

#Preview {
    HomeView()
}
