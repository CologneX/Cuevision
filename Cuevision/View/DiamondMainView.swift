import SwiftUI

struct DiamondMainView: View {
    @State private var offsetCueball = CGPoint(x: 0, y: 0)
    @State private var offsetTargetBall = CGPoint(x: 100, y: 0)
    
    @State private var startLocationCueball: CGPoint = .zero
    @State private var startLocationTargetBall: CGPoint = CGPoint(x: 100, y: 0)
    
    @State private var showOverlay = false
    @State private var isActive = false
    
    let diamondsLeft = [
        CGPoint(x: 140.0, y: 55.0), CGPoint(x: 140.0, y: 85.66665649414062),
        CGPoint(x: 140.0, y: 121.33332824707031), CGPoint(x: 140.0, y: 151.33334350585938),
        CGPoint(x: 140.0, y: 183.66665649414062), CGPoint(x: 140.0, y: 212.6666717529297),
        CGPoint(x: 140.0, y: 244.0), CGPoint(x: 140.0, y: 275.6666717529297),
        CGPoint(x: 140.0, y: 301.3333435058594)
    ]
    
    let diamondsRight = [
        CGPoint(x: 665.0, y: 306.3333435058594), CGPoint(x: 665.0, y: 273.3333282470703),
        CGPoint(x: 665.0, y: 241.6666717529297), CGPoint(x: 665.0, y: 210.0),
        CGPoint(x: 665.0, y: 178.6666717529297), CGPoint(x: 665.0, y: 148.0),
        CGPoint(x: 665.0, y: 119.66667175292969), CGPoint(x: 665.0, y: 85.66667175292969),
        CGPoint(x: 665.0, y: 64.33332824707031)
    ]
    
    let diamondsTop = [
        CGPoint(x: 685.0, y: 70.0), CGPoint(x: 622.6666564941406, y: 70.0),
        CGPoint(x: 550.3333282470703, y: 70.0), CGPoint(x: 480.6666717529297, y: 70.0),
        CGPoint(x: 397.3333435058594, y: 70.0), CGPoint(x: 329.3333282470703, y: 70.0),
        CGPoint(x: 256.6666717529297, y: 70.0), CGPoint(x: 185.3333282470703, y: 70.0),
        CGPoint(x: 120.66667175292969, y: 70.0)
    ]
    
    let diamondsBottom = [
        CGPoint(x: 144.0, y: 300.0), CGPoint(x: 186.33334350585938, y: 300.0),
        CGPoint(x: 255.0, y: 300.0), CGPoint(x: 324.6666717529297, y: 300.0),
        CGPoint(x: 403.0, y: 300.0), CGPoint(x: 479.6666717529297, y: 300.0),
        CGPoint(x: 552.0, y: 300.0), CGPoint(x: 618.3333282470703, y: 300.0),
        CGPoint(x: 659.6666564941406, y: 300.0)
    ]
    
    let tableEdges = (
        bottomLeft: CGPoint(x: 136.66665649414062, y: 305.6666717529297),
        topLeft: CGPoint(x: 142.6666717529297, y: 69.66665649414062),
        topRight: CGPoint(x: 662.0, y: 68.33334350585938),
        bottomRight: CGPoint(x: 661.3333435058594, y: 300.6666564941406)
    )
    
    func nearestDiamond(to point: CGPoint, in diamonds: [CGPoint]) -> CGPoint {
        return diamonds.min(by: { distance(from: $0, to: point) < distance(from: $1, to: point) }) ?? CGPoint.zero
    }
    
    func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
    }
    
    func calculateAimDiamond(cueBall: CGPoint, targetBall: CGPoint) -> CGPoint {
        let S = nearestDiamond(to: cueBall, in: diamondsLeft + diamondsRight + diamondsTop + diamondsBottom)
        let F = nearestDiamond(to: targetBall, in: diamondsLeft + diamondsRight + diamondsTop + diamondsBottom)
        
        // Find the reflection diamond point
        var aimDiamond = S
        
        if S.x == F.x { // Vertical reflection
            aimDiamond = nearestDiamond(to: CGPoint(x: S.x, y: 2 * S.y - F.y), in: diamondsLeft + diamondsRight + diamondsTop + diamondsBottom)
        } else if S.y == F.y { // Horizontal reflection
            aimDiamond = nearestDiamond(to: CGPoint(x: 2 * S.x - F.x, y: S.y), in: diamondsLeft + diamondsRight + diamondsTop + diamondsBottom)
        } else { // Diagonal reflection
            if S.x < F.x {
                aimDiamond = nearestDiamond(to: CGPoint(x: 2 * S.x - F.x, y: S.y), in: diamondsLeft + diamondsRight + diamondsTop + diamondsBottom)
            } else {
                aimDiamond = nearestDiamond(to: CGPoint(x: S.x, y: 2 * S.y - F.y), in: diamondsLeft + diamondsRight + diamondsTop + diamondsBottom)
            }
        }
        
        // Ensure aim diamond is within table edges
        let aimX = max(min(aimDiamond.x, tableEdges.topRight.x), tableEdges.topLeft.x)
        let aimY = max(min(aimDiamond.y, tableEdges.bottomLeft.y), tableEdges.topLeft.y)
        
        return CGPoint(x: aimX, y: aimY)
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image(.poolBackground) // Ganti dengan nama file background yang sesuai
                    .resizable()
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    let widthPoolBoundary = geometry.size.width * 0.74
                    let heightPoolBoundary = geometry.size.height * 0.7
                    
                    ZStack {
                        Image(.billiardWithDiamond)  // Ganti dengan nama file meja billiard yang sesuai
                            .resizable()
                            .scaledToFill()
                            .padding(.horizontal, 30)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        // Boundary background
                        Rectangle()
                            .stroke(Color.blue, lineWidth: 5)
                            .frame(width: widthPoolBoundary, height: heightPoolBoundary)
                            .background(Color.red.opacity(0.2))
                            .scaledToFit()
                        
                        let cueballPosition = CGPoint(x: offsetCueball.x + geometry.size.width / 2, y: offsetCueball.y + geometry.size.height / 2)
                        let targetBallPosition = CGPoint(x: offsetTargetBall.x + geometry.size.width / 2, y: offsetTargetBall.y + geometry.size.height / 2)
                        let aimDiamond = calculateAimDiamond(cueBall: cueballPosition, targetBall: targetBallPosition)
                        
                        Image(.cueball)  // Ganti dengan nama file gambar bola cue yang sesuai
                            .resizable()
                            .frame(width: 25, height: 25)
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
                        
                        Image(.solidOne)  // Ganti dengan nama file gambar bola target yang sesuai
                            .resizable()
                            .frame(width: 25, height: 25)
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
                        // Drawing the path with reflection within the billiard table boundaries
                        Path { path in
                            path.move(to: cueballPosition)
                            path.addLine(to: aimDiamond)
                            path.addLine(to: targetBallPosition)
                        }
                        .stroke(Color.green, lineWidth: 3)
                        
                        // Add a circle to mark the aim diamond point
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                            .position(aimDiamond)
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
                        .position(x: widthPoolBoundary*1.15, y: heightPoolBoundary*0.75)
                        .animation(.default, value: showOverlay)
                        .edgesIgnoringSafeArea(.bottom)
                        .edgesIgnoringSafeArea(.trailing)
                    } else {
                        AnalysisDiamondView()
                            .position(x: widthPoolBoundary*1.712, y: heightPoolBoundary*0.75)
                            .frame(maxHeight: .infinity)
                            .ignoresSafeArea()
                        
                        HStack {
                            Spacer()
                            Button {
                                //                                    withAnimation(.bouncy) {
                                //                                        showOverlay.toggle()
                                //                                    }
                                self.isActive = true
                            } label: {
                                Text("Done")
                                    .fontWeight(.bold)
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                            .tint(.white)
                            .foregroundColor(.darkGreen)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .offset(x: 16, y: -12)
                            
                            NavigationLink(destination: HomeView(), isActive: $isActive) {
                                EmptyView()
                            }
                            .background(.red)
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
}

struct DiamondMainView_Previews: PreviewProvider {
    static var previews: some View {
        DiamondMainView()
    }
}
