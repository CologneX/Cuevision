import SwiftUI

struct DiamondMainView: View {
    // MARK: Camera Functions and Variables
    @Binding var image: UIImage?
    
    @ObservedObject var cameraModel: CameraModel
    
    @ObservedObject var ballClassificationModel: BilliardBallClassifier
    
    @State var detectedObjects: [DetectedObject] = []
    
    @Binding var isShowingPhotoDisplay: Bool
    
    private func classifyImage() {
        ballClassificationModel.classify(image: image!) { [self] results in
            DispatchQueue.main.async {
                self.detectedObjects = results
                print(results.debugDescription)
            }
        }
    }
    
    // MARK: Standalone Functions and Variables
    @State private var offsetCueball = CGPoint(x: 0, y: 0)
    @State private var offsetTargetBall = CGPoint(x: 100, y: 0)
    
    @State private var startLocationCueball: CGPoint = .zero
    @State private var startLocationTargetBall: CGPoint = CGPoint(x: 100, y: 0)
    
    @State private var showOverlay = false
    @State private var analysisDiamondVM = AnalysisDiamondViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    private func ballImageName(_ number: String) -> ImageResource {
        switch number {
        case "1": return .one
        case "2": return .two
        case "3": return .three
        case "4": return .four
        case "5": return .five
        case "6": return .six
        case "7": return .seven
        case "8": return .eight
        case "9": return .nine
        case "10": return .ten
        case "11": return .eleven
        case "12": return .twelve
        case "13": return .thirteen
        case "14": return .fourteen
        case "15": return .fifteen
        default : return .white
        }
    }
    var body: some View {
        NavigationStack {
            ZStack{
                Image(.poolBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    ZStack {
                        Image(.billiardWithDiamond)
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 30)
                            .frame(height: geometry.size.height)
                            .overlay{
                                GeometryReader{ gg in
                                    Text("")
                                        .onAppear {
                                            analysisDiamondVM.heightPoolBoundary = gg.size.height * 0.65
                                            analysisDiamondVM.widthPoolBoundary = gg.size.width * 0.7
                                        }
                                }
                            }
                        
                        // Boundary background
                        Rectangle()
                            .stroke(Color.blue, lineWidth: 0.1)
                            .frame(width: analysisDiamondVM.widthPoolBoundary, height: analysisDiamondVM.heightPoolBoundary)
                            .background(Color.red.opacity(0))
                            .scaledToFit()
                        
                        let cueballPosition = CGPoint(x: offsetCueball.x + analysisDiamondVM.widthPoolBoundary / 2, y: abs(offsetCueball.y - analysisDiamondVM.heightPoolBoundary / 2))
                        
                        let targetBallPosition = CGPoint(x: offsetTargetBall.x + analysisDiamondVM.widthPoolBoundary / 2, y: abs(offsetTargetBall.y - analysisDiamondVM.heightPoolBoundary / 2))
                        
                        let aimDiamond = analysisDiamondVM.calculateReflectionPoint(cueBall: cueballPosition, targetBall: targetBallPosition)
                        
                        
                        Image(.cueball)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .shadow(color: .black, radius: 2, x: 3, y: 4)
                            .offset(x: offsetCueball.x, y: offsetCueball.y)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        let newOffset = CGPoint(x: self.startLocationCueball.x + gesture.translation.width, y: self.startLocationCueball.y + gesture.translation.height)
                                        
                                        // Constrain the offset within the container
                                        if newOffset.x >= -(analysisDiamondVM.widthPoolBoundary/2) && newOffset.x <= analysisDiamondVM.widthPoolBoundary/2 &&
                                            newOffset.y >= -(analysisDiamondVM.heightPoolBoundary/2) && newOffset.y <= analysisDiamondVM.heightPoolBoundary/2 {
                                            self.offsetCueball = newOffset
                                        }
                                        
                                    }
                                    .onEnded { gesture in
                                        self.startLocationCueball = self.offsetCueball
                                        
                                        let cueballCoordinateAfterTranslation = analysisDiamondVM.findPointTranslation(from: self.startLocationCueball, widthPoolBoundary: analysisDiamondVM.widthPoolBoundary, heightPoolBoundary: analysisDiamondVM.heightPoolBoundary)
                                        
                                        analysisDiamondVM.cueBallCoordinate = cueballCoordinateAfterTranslation
                                    }
                            )
                        
                        ForEach(detectedObjects, id: \.label) { poolBalls in
                            let boundingBox = CGRect(
                                x: poolBalls.boundingBox.minX * geometry.size.width,
                                y: poolBalls.boundingBox.minY * geometry.size.height,
                                width: poolBalls.boundingBox.width * geometry.size.width,
                                height: poolBalls.boundingBox.height * geometry.size.height
                            )
                            
                            Image(ballImageName(poolBalls.label))
                                .resizable()
                                .frame(width: boundingBox.width, height: 25)
                                .position(x: boundingBox.midX, y: boundingBox.midY)
                                .shadow(color: .black, radius: 2, x: 3, y: 4)
                        }
                        
                        Image(.one)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .shadow(color: .black, radius: 2, x: 3, y: 4)
                            .offset(x: offsetTargetBall.x, y: offsetTargetBall.y)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        let newOffset = CGPoint(x: self.startLocationTargetBall.x + gesture.translation.width, y: self.startLocationTargetBall.y + gesture.translation.height)
                                        
                                        // Constrain the offset within the container
                                        if newOffset.x >= -(analysisDiamondVM.widthPoolBoundary/2) && newOffset.x <= analysisDiamondVM.widthPoolBoundary/2 &&
                                            newOffset.y >= -(analysisDiamondVM.heightPoolBoundary/2) && newOffset.y <= analysisDiamondVM.heightPoolBoundary/2 {
                                            self.offsetTargetBall = newOffset
                                        }
                                        
                                    }
                                    .onEnded { _ in
                                        self.startLocationTargetBall = self.offsetTargetBall
                                        
                                        let targetBallCoordinateAfterTranslation = analysisDiamondVM.findPointTranslation(from: self.startLocationTargetBall, widthPoolBoundary: analysisDiamondVM.widthPoolBoundary, heightPoolBoundary: analysisDiamondVM.heightPoolBoundary)
                                        
                                        analysisDiamondVM.targetBallCoordinate = targetBallCoordinateAfterTranslation
                                    }
                            )
                        
                        // Drawing the path with reflection within the billiard table boundaries
                        // titik anchor berada di kiri atas
                        Path { path in
                            path.move(to:CGPoint(x: offsetCueball.x + geometry.size.width / 2, y: offsetCueball.y + geometry.size.height / 2))
                            path.addLine(to: CGPoint(x: aimDiamond.x + geometry.size.width / 2,  y: aimDiamond.y + geometry.size.height / 2))
                            path.addLine(to: CGPoint(x: offsetTargetBall.x + geometry.size.width / 2, y: offsetTargetBall.y + geometry.size.height / 2))
                        }
                        .stroke(Color.white, style: .init(lineWidth: 2, dash: [5]))
                        
                        // Add a circle to mark the aim diamond point
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                            .position(CGPoint(x: aimDiamond.x + geometry.size.width / 2,  y: aimDiamond.y + geometry.size.height / 2))
                    }
                    .onAppear {
                        classifyImage()
                        print("Frame Width: \(geometry.size.width), Height: \(geometry.size.height), Image: \(image!.size.width), \(image!.size.height)")
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
                        // posisi analysis nyala
                        VStack {
                            AnalysisDiamondView(analysisDiamondVM: $analysisDiamondVM)
                        }
                        .offset(x: 1 * (geometry.size.width / 2) )
                        .animation(.default, value: showOverlay)
                        .ignoresSafeArea()
                    } else {
                        // posisi default
                        AnalysisDiamondView(analysisDiamondVM: $analysisDiamondVM)
                            .offset(x: 2 * (geometry.size.width / 2) + 20)
                            .ignoresSafeArea()
                        
                        HStack {
                            Spacer()
                            Button {
                                presentationMode.wrappedValue.dismiss()
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
                        }
                    }
                }
            }
            .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                .onEnded { value in
                    switch(value.translation.width, value.translation.height) {
                    case (...0, -30...30):
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
        .navigationBarBackButtonHidden()
    }
}

//#Preview{
//    DiamondMainView()
//}
