import SwiftUI

struct DiamondMainView: View {
    // MARK: Camera Functions and Variables
    @Binding var image: UIImage?
    @ObservedObject var cameraModel: CameraModel
    @ObservedObject var ballClassificationModel: BilliardBallClassifier
    @State var detectedObjects: [DetectedObject] = []
    @Binding var isShowingPhotoDisplay: Bool
    
    private func classifyImage(_ geometry: GeometryProxy) {
        ballClassificationModel.classify(image: image!) { [self] results in
            DispatchQueue.main.async {
                self.detectedObjects = results
                self.detectedObjects.indices.forEach { i in
                    detectedObjects[i].position = scalePosition(detectedObjects[i].position, geometry: geometry)
                }
            }
        }
    }
    private func scalePosition(_ position: CGPoint, geometry: GeometryProxy) -> CGPoint {
        let x = (position.x * geometry.size.width) /*/ scale*/
        let y = (position.y * geometry.size.height) /*/ scale*/
        return CGPoint(x: x, y: y)
    }
    
    // MARK: Standalone Functions and Variables
    @StateObject var navigationVM : NavigationViewModel
    @State private var showOverlay = false
    @State private var analysisDiamondVM = AnalysisDiamondViewModel()
    @State private var scale: CGFloat = 1.0
    
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
        GeometryReader { geo in
            Image(.poolBackground)
                .resizable()
                .ignoresSafeArea()
            Image(.billiardWithDiamond)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
//                .aspectRatio(16/9, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 16)
                .overlay {
                    GeometryReader { gg in
                        ZStack {
                            ForEach(Array(detectedObjects.enumerated()), id: \.offset) { index, poolBall in
                                Image(ballImageName(poolBall.label))
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .shadow(color: .black, radius: 2, x: 3, y: 4)
                                    .position(poolBall.position)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { gesture in
                                                let newPosition = CGPoint(
                                                    x : min(max(gesture.location.x, gg.size.width - analysisDiamondVM.widthPoolBoundary), analysisDiamondVM.widthPoolBoundary),
                                                    y : min(max(gesture.location.y, gg.size.height - analysisDiamondVM.heightPoolBoundary), analysisDiamondVM.heightPoolBoundary)
                                                )
                                                if let index = detectedObjects.firstIndex(where: { $0.id == poolBall.id }) {
                                                    detectedObjects[index].position = newPosition
                                                    if poolBall.label == "white" {
                                                        analysisDiamondVM.cueBallCoordinate = newPosition
                                                    } else {
                                                        analysisDiamondVM.targetBallCoordinate = newPosition
                                                    }
                                                }
                                            }
                                    )
                            }
                            // Line that connects the cue ball and target ball
                            if analysisDiamondVM.cueBallCoordinate != .zero && analysisDiamondVM.targetBallCoordinate != .zero {
                                let aimDiamond = analysisDiamondVM.calculateReflectionPoint(cueBall: analysisDiamondVM.cueBallCoordinate, targetBall: analysisDiamondVM.targetBallCoordinate)
                                Path { path in
                                    path.move(to: analysisDiamondVM.cueBallCoordinate)
                                    path.addLine(to: CGPoint(x: aimDiamond.x + gg.size.width / 2,  y: aimDiamond.y + gg.size.height / 2))
                                    path.addLine(to: analysisDiamondVM.targetBallCoordinate)
                                }
                                .stroke(Color.white, style: .init(lineWidth: 2, dash: [5]))
//                                Circle()
//                                    .fill(Color.red)
//                                    .frame(width: 10, height: 10)
//                                //                                    .position(CGPoint(x: ((aimDiamond.x + (gg.size.width + (gg.size.width * 0.215))) / 2),  y: ((aimDiamond.y + (gg.size.height + (gg.size.height * 0.118))) / 2)))
//                                    .position(CGPoint(x: (aimDiamond.x + gg.size.width  / 2),  y: ((aimDiamond.y + gg.size.height) / 2)))
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .position(CGPoint(x: aimDiamond.x + gg.size.width / 2,  y: aimDiamond.y + gg.size.height / 2))
                            }
                        }
                        .onAppear {
                            scale = image!.size.width /  gg.size.width
                            analysisDiamondVM.heightPoolBoundary = gg.size.height * 0.785
                            analysisDiamondVM.widthPoolBoundary = gg.size.width * 0.882
                            classifyImage(gg)
                        }
                    }
                    .overlay(alignment: .topLeading, content: {
                        Button(action: {
                            navigationVM.goToFirstScreen()
                        }) {
                            Image("BackCross")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                        }
                        .padding(.top, 24)
                        .padding(.leading, -24)
                    })
                }
                .ignoresSafeArea(.all, edges: .vertical)
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
                .offset(x: 1 * (geo.size.width / 2) )
                .animation(.default, value: showOverlay)
                .ignoresSafeArea()
            }
            else {
                // posisi default
                AnalysisDiamondView(analysisDiamondVM: $analysisDiamondVM)
                    .offset(x: 2 * (geo.size.width / 2) + 20)
                    .ignoresSafeArea()
                
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.default) {
                            isShowingPhotoDisplay = false
                        }
                    } label: {
                        
                        Image(systemName: "camera.fill")
                            .font(.title2)
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 12)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle)
                    .tint(.white)
                    .foregroundColor(.darkGreen)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .offset(x: 48, y: -12)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                switch(value.translation.width, value.translation.height) {
                case (...0, -30...30):
                    showOverlay.toggle()
                default:  return
                }
            }
        )
        .animation(.snappy, value: showOverlay)
        .navigationBarBackButtonHidden()
    }
}

//#Preview{
//    DiamondMainView()
//}


