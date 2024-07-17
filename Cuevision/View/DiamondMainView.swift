//
//  DiamondMainView.swift
//  Cuevision
//
//  Created by Fachmi Dimas Ardhana on 17/07/24.
//

import SwiftUI

struct DiamondMainView: View {
    @State private var offsetCueball = CGSize.zero
    @State private var offsetTargetBall = CGSize(width: 0, height: 0)
    
    @State private var startLocationCueball: CGSize = .zero
    @State private var startLocationTargetBall: CGSize = .zero
    
    var body: some View {
        ZStack{
            Image(.poolBackground)
            
            GeometryReader { geometry in
                ZStack {
                    Image(.billiardWithDiamond)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 220)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            print("width: \()")
                        }
                    
                    // Boundary background
                    Rectangle()
                        .stroke(Color.blue, lineWidth: 5)
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.52)
                        .background(Color.red.opacity(0.2))
                    
                    Image(.cueball)
                        .resizable()
                        .frame(maxWidth: 25, maxHeight: 25)
                        .shadow(color: .black, radius: 2, x: 3, y: 4)
                        .offset(x: offsetCueball.width, y: offsetCueball.height)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offsetCueball = CGSize(width: self.startLocationCueball.width + gesture.translation.width, height: self.startLocationCueball.height + gesture.translation.height)
                                    
                                    print("Cueball coordinates: (\(self.offsetCueball.width), \(self.offsetCueball.height))")
                                }
                                .onEnded { gesture in
                                    self.startLocationCueball = self.offsetCueball
                                }
                        )
                    //                        .gesture(
                    //                            DragGesture()
                    //                                .onChanged { gesture in
                    //                                    if self.startLocationCueball == nil {
                    //                                        self.startLocationCueball = self.offsetCueball
                    //                                    }
                    //
                    //                                    let translation = CGSize(width: gesture.translation.width, height: gesture.translation.height)
                    //                                    let newOffset = CGSize(
                    //                                        width: min(max(self.startLocationCueball.width + translation.width, 0), geometry.size.width - 100),
                    //                                        height: min(max(self.startLocationCueball.height + translation.height, 0), geometry.size.height - 100)
                    //                                    )
                    //                                    self.offsetCueball = newOffset
                    //                                }
                    //                                .onEnded { _ in
                    //                                    self.startLocationCueball = .zero // Reset startLocation after drag ends
                    //                                }
                    //                        )
                    //                        .clipped() // Ensure image stays within the GeometryReader bounds
                        .padding(.leading, 300)
                    
                    Image(.solidOne)
                        .resizable()
                        .frame(maxWidth: 25, maxHeight: 25)
                        .shadow(color: .black, radius: 2, x: 3, y: 4)
                        .offset(x: offsetTargetBall.width, y: offsetTargetBall.height)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offsetTargetBall = CGSize(width: self.startLocationTargetBall.width + gesture.translation.width, height: self.startLocationTargetBall.height + gesture.translation.height)
                                    
                                    print("Target Ball coordinates: (\(self.offsetTargetBall.width), \(self.offsetTargetBall.height))")
                                }
                                .onEnded { _ in
                                    self.startLocationTargetBall = self.offsetTargetBall
                                }
                        )
                        //.padding(.leading, -200)
                }
                .padding(.top, 25)
            }
            
        }
    }
}

#Preview {
    DiamondMainView()
}
