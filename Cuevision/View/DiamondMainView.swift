//
//  DiamondMainView.swift
//  Cuevision
//
//  Created by Fachmi Dimas Ardhana on 17/07/24.
//

import SwiftUI

struct DiamondMainView: View {
    @State private var offsetCueball = CGPoint(x: 0, y: 0)
    @State private var offsetTargetBall = CGPoint(x: 100, y: 0)
    
    @State private var startLocationCueball: CGPoint = .zero
    @State private var startLocationTargetBall: CGPoint = CGPoint(x: 100, y: 0)
    
    @State private var showOverlay = false
    
    var body: some View {
        ZStack{
            Image(.poolBackground)
                .resizable()
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                let widthPoolBoundary = geometry.size.width * 0.74
                let heightPoolBoundary = geometry.size.height * 0.7
                
                ZStack {
                    Image(.billiardWithDiamond)
                        .resizable()
                        .scaledToFill()
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Boundary background
                    Rectangle()
                        .stroke(Color.blue, lineWidth: 5)
                        .frame(width: widthPoolBoundary, height: heightPoolBoundary)
                        .background(Color.red.opacity(0.2))
                    
                    Image(.cueball)
                        .resizable()
                        .frame(maxWidth: 25, maxHeight: 25)
                        .shadow(color: .black, radius: 2, x: 3, y: 4)
                        .offset(x: offsetCueball.x, y: offsetCueball.y)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    let newOffset = CGPoint(x: self.startLocationCueball.x + gesture.translation.width, y: self.startLocationCueball.y + gesture.translation.height)
                                    
                                    // Constrain the offset within the container
                                    if newOffset.x >= -(widthPoolBoundary/2) && newOffset.x <= widthPoolBoundary/2 &&
                                        newOffset.y >= -(heightPoolBoundary/2) && newOffset.y <= heightPoolBoundary/2 {
                                        self.offsetCueball = newOffset
                                    }
                                    
                                }
                                .onEnded { gesture in
                                    self.startLocationCueball = self.offsetCueball
                                    
                                    print("Cueball coordinates: (\(self.offsetCueball.x), \(self.offsetCueball.y)) -- \(self.startLocationCueball)")
                                }
                        )
                    
                    Image(.solidOne)
                        .resizable()
                        .frame(maxWidth: 25, maxHeight: 25)
                        .shadow(color: .black, radius: 2, x: 3, y: 4)
                        .offset(x: offsetTargetBall.x, y: offsetTargetBall.y)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    let newOffset = CGPoint(x: self.startLocationTargetBall.x + gesture.translation.width, y: self.startLocationTargetBall.y + gesture.translation.height)
                                    
                                    // Constrain the offset within the container
                                    if newOffset.x >= -(widthPoolBoundary/2) && newOffset.x <= widthPoolBoundary/2 &&
                                        newOffset.y >= -(heightPoolBoundary/2) && newOffset.y <= heightPoolBoundary/2 {
                                        self.offsetTargetBall = newOffset
                                    }
                                    
                                }
                                .onEnded { _ in
                                    self.startLocationTargetBall = self.offsetTargetBall
                                    
                                    print("Target Ball coordinates: (\(self.offsetTargetBall.x), \(self.offsetTargetBall.y)) -- \(self.startLocationTargetBall)")
                                }
                        )
                }
                .padding(.top, 12)
                
                // Overlay view
                if showOverlay {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation(.default) {
                                showOverlay.toggle()
                            }
                        }
                    
                    VStack {
                        AnalysisDiamondView()
                    }
                    .offset(x: widthPoolBoundary - 140)
                    .animation(.default, value: showOverlay)
                    .edgesIgnoringSafeArea(.bottom)
                    .edgesIgnoringSafeArea(.trailing)
                } else {
                    AnalysisDiamondView()
                        .offset(x: widthPoolBoundary+150, y: 12)
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.bouncy) {
                                showOverlay.toggle()
                            }
                        } label: {
                            Text("Simulate")
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .tint(.white)
                        .foregroundColor(.darkGreen)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .offset(x: 16, y: -12)
                    }
                }
            }
        }
        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                print(value.translation)
                switch(value.translation.width, value.translation.height) {
                case (...0, -30...30):
                    print("left swipe")
                    showOverlay.toggle()
                case (0..., -30...30):  print("right swipe")
                case (-100...100, ...0):  print("up swipe")
                case (-100...100, 0...):  print("down swipe")
                default:  print("no clue")
                }
            }
        )
        .animation(.default, value: showOverlay)
    }
}

#Preview {
    DiamondMainView()
}
