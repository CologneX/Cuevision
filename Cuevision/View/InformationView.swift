//
//  InformationView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 17/07/24.
//

import SwiftUI

struct InformationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var navigationVM : NavigationViewModel
    
    struct BilliardTips: Hashable {
        var image: ImageResource
        var title: String
        var subtitle: String
    }
    
    var dataBilliardTips = [
        BilliardTips(image: .one, title: "Cue Ball Effect", subtitle: "Get to know Cue ball hit effect points"),
        BilliardTips(image: .two, title: "Hand Form", subtitle: "Stabilize cue stick handling with different hand form"),
        BilliardTips(image: .three, title: "Diamond System", subtitle: "Learn to aim accurately using the Diamond System")
    ]
    
    var body: some View {
        ZStack{
            Image(.infoBG)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(alignment:.center, spacing: 24) {
                    ForEach(dataBilliardTips, id: \.self) { data in
                        Button {
                            switch(data.title) {
                            case "Cue Ball Effect":
                                navigationVM.goToNextPage(.CueBallView)
                            case "Hand Form":
                                navigationVM.goToNextPage(.HandFormView)
                            default:
                                return
                            }
                        } label: {
                            HStack {
                                Image(data.image)
                                    .resizable()
                                    .frame(width: 250, height: 250)
                                    .padding(.trailing, 24)
                                VStack {
                                    Text(data.title)
                                        .font(Font.custom("SFPro-ExpandedBold", size: 40.0))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text(data.subtitle)
                                        .font(.callout)
                                        .foregroundStyle(.white)
                                        .padding(.top, -20)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: 700)
                        }
                    }
                }
                .padding(.all, 50)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            .overlay(alignment: .topLeading) {
                Button {
                    navigationVM.backToPreviousPage()
                } label: {
                    Image("back")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .padding(.top, 36)
                .padding(.leading, 16)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    InformationView(navigationVM: NavigationViewModel())
}
