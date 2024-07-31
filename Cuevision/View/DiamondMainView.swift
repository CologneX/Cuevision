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
                // Assign the cue ball (white ball) and target ball position (first one in the array without label white)
                self.analysisDiamondVM.cueBallCoordinate = detectedObjects.first(where: { $0.label == "white" })?.position ?? .zero
                self.analysisDiamondVM.targetBallCoordinate = detectedObjects.first(where: { $0.label != "white" })?.position ?? .zero
            }
        }
    }
    private func scalePosition(_ position: CGPoint, geometry: GeometryProxy) -> CGPoint {
        let x = (position.x * geometry.size.width) /*/ scale*/
        let y = (position.y * geometry.size.height) /*/ scale*/
        return CGPoint(x: x, y: y)
    }
    
    // MARK: Standalone Functions and Variables
    @Environment(\.presentationMode) var presentationMode
    @StateObject var navigationVM : NavigationViewModel
    @State private var showOverlay = false
    @State private var analysisDiamondVM = AnalysisDiamondViewModel()
    @State private var boundaryOrigin: CGPoint = .zero
    
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
    private var transformedCueBallPosition: CGPoint {
        let translatedX = analysisDiamondVM.cueBallCoordinate.x - boundaryOrigin.x
        let translatedY = analysisDiamondVM.cueBallCoordinate.y  - boundaryOrigin.y
        return CGPoint(x: translatedX, y: analysisDiamondVM.heightPoolBoundary - translatedY - 17.5)
    }
    private var transformedTargetBallPosition: CGPoint {
        let translatedX = analysisDiamondVM.targetBallCoordinate.x - boundaryOrigin.x
        let translatedY = analysisDiamondVM.targetBallCoordinate.y - boundaryOrigin.y
        return CGPoint(x: translatedX, y: analysisDiamondVM.heightPoolBoundary - translatedY - 17.5)
    }
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.poolBackground)
                    .resizable()
                    .ignoresSafeArea()
                Image(.poolWithDiamond)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
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
                                                    let minX = (gg.size.width * 0.20) / 2 + 12.5
                                                    let minY = (gg.size.height * 0.38) / 2
                                                    let maxX = analysisDiamondVM.widthPoolBoundary + minX - 25
                                                    let maxY = analysisDiamondVM.heightPoolBoundary + minY - 5
                                                    let newPosition = CGPoint(
                                                        x: min(max(gesture.location.x, minX), maxX),
                                                        y: min(max(gesture.location.y, minY), maxY)
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
                                    let aimDiamond = analysisDiamondVM.calculateReflectionPoint(cueBall: transformedCueBallPosition, targetBall: transformedTargetBallPosition)
                                    Path { path in
                                        path.move(to: analysisDiamondVM.cueBallCoordinate)
                                        path.addLine(to: CGPoint(x: aimDiamond.x + gg.size.width / 2,  y: aimDiamond.y + gg.size.height / 2))
                                        path.addLine(to: analysisDiamondVM.targetBallCoordinate)
                                    }
                                    .stroke(Color.white, style: .init(lineWidth: 2, dash: [5]))
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 10, height: 10)
                                        .position(CGPoint(x: aimDiamond.x + gg.size.width / 2,  y: aimDiamond.y + gg.size.height / 2))
                                }
                            }
                            .onAppear {
                                analysisDiamondVM.heightPoolBoundary = gg.size.height * 0.62
                                analysisDiamondVM.widthPoolBoundary = gg.size.width * 0.80
                                boundaryOrigin = CGPoint(x: ((gg.size.width - analysisDiamondVM.widthPoolBoundary) / 2 + 12.5),
                                                         y: ((gg.size.height - analysisDiamondVM.heightPoolBoundary) / 2 + 12.5))
                                print(boundaryOrigin)
                                classifyImage(gg)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                
            }
            .overlay(alignment: .topLeading, content: {
                Button(action: {
                    navigationVM.goToFirstScreen()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(Circle())
                })
                .padding(.top, 24)
                .padding(.leading, -36)
            })
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


