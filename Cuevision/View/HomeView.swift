//
//  HomeView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 16/07/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var navigationVM = NavigationViewModel()
    @StateObject var cameraModel = CameraModel()
    @StateObject var ballClassificationModel = BilliardBallClassifier()
    var body: some View {
        NavigationStack(path: $navigationVM.path) {
            ZStack {
                Image("HomeBG")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    GeometryReader { geometry in
                        HStack {
                            Text("\"Learn How To Aim Better Using Diamond System\"")
                                .font(Font.custom("SFPro-ExpandedBold", fixedSize: 20.0))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .minimumScaleFactor(0.5)
                                .allowsTightening(true)
                                .frame(maxWidth: geometry.size.width * 0.8)
                                .padding(.bottom, 20)
                            
                            VStack(spacing: 20) {
                                Button {
                                    navigationVM.goToNextPage(.CameraView)
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
                                    navigationVM.goToNextPage(.InformationView)
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
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                }
                .padding(.horizontal, 48)
            }
            .navigationDestination(for: NavigationPaths.self) { path in
                switch path {
                case .InformationView:
                    InformationView(navigationVM: navigationVM)
                case .CameraView:
                    CameraView(cameraModel: cameraModel, ballClassificationModel: ballClassificationModel, navigationVM: navigationVM)
                case .CueBallView:
                    CueBallEffectView()
                case .HandFormView:
                    HandFormView()
//                case "Diamond View":
//                    DiamondMainView()
                default:
                    DiamondSystemView()
                }
            }
        }
    }
}
