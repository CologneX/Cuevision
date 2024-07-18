//
//  OnboardingView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 18/07/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    
    var body: some View {
        NavigationView{
            ZStack {
                Image("InfoBG")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    TabView(selection: $currentPage) {
                        VStack {
                            Image("ball3")
                                .resizable()
                                .frame(width: 200, height: 200)
                            
                            Text("Focus, Aim, Win")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding()
                            
                            Text("Improve your aim using diamond system scanner")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .tag(0)
                        
                        VStack {
                            Image("OnboardingInfo")
                                .padding(.leading, 50)
                            
                            NavigationLink(destination: HomeView()) {
                                Text("Get Started")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 70)
                                    .padding(.vertical, 15)
                                    .background(Color.white)
                                    .foregroundColor(Color(hex: 0x428365))
                                    .cornerRadius(30)
                            }
                        }
                        .padding()
                        .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    ZStack{
                        Rectangle()
                            .frame(width: 40, height: 20)
                            .cornerRadius(20)
                            .foregroundColor(Color(hex: 0x89A597))
                        
                        HStack {
                            ForEach(0..<2) { index in
                                Circle()
                                    .fill(index == currentPage ? Color.black : Color(hex: 0x617469))
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}
