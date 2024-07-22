//
//  HomeView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 16/07/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                Image("HomeBG")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                HStack{
                    Text("'Focus. Aim. Win'").font(Font.custom("SFPro-ExpandedBold", size: 20.0))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    
                    Spacer()
                    
                    VStack{
                        NavigationLink(destination: CameraView()){
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
                        .shadow(radius: 10, x: 0, y: 4)
                        //                    .padding(.trailing, 20)
                        
                        Spacer()
                        
                        NavigationLink(destination: InformationView()){
                            Text("Billiard Tips")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(Color.white)
                                .foregroundColor(Color(hex: 0x428365))
                                .cornerRadius(30)
                        }
                        .shadow(radius: 10, x: 0, y: 4)
                        //                    .padding(.trailing, 20)
                    }
                    .padding(30)
                }
                .padding(70)
            }
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
