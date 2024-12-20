//
//  InformationView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 17/07/24.
//

import SwiftUI

struct InformationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Bindable var navigationVM : NavigationViewModel
    
    struct BilliardTips: Hashable {
        var image: String
        var title: String
        var subtitle: String
    }
    
    let dataBilliardTips = [
        BilliardTips(image: "solid_one", title: "Cue Ball Effect", subtitle: "knowing cue ball hit point effect"),
        BilliardTips(image: "solid_two", title: "Hand Form", subtitle: "stabilize your cue stick using different hand form"),
        BilliardTips(image: "solid_three", title: "Diamond System", subtitle: "learn how to aim more accurately using diamond system")
    ]
    
    var body: some View {
        ScrollView {
            ZStack {
                Image(.infoBG)
                    .scaledToFit()
                
                LazyVStack(alignment:.center, spacing: 24) {
                    ForEach(dataBilliardTips, id: \.self) { data in
                        Button {
                            switch(data.title) {
                            case "Cue Ball Effect":
                                navigationVM.goToNextPage(screenName: "Cue Ball Effect")
                                break
                            case "Hand Form":
                                navigationVM.goToNextPage(screenName: "Hand Form")
                                break
                            case "Diamond System":
                                navigationVM.goToNextPage(screenName: "Diamond System")
                                break
                            default:
                                return
                            }
                        } label: {
                            HStack {
                                Image("\(data.image)")
                                    .resizable()
                                    .frame(width: 250, height: 250)
                                    .padding(.trailing, 24)
                                VStack {
                                    Text("\(data.title)")
                                        .font(Font.custom("SFPro-ExpandedBold", size: 40.0))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text("\(data.subtitle)")
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
            }
            .padding(.all, -60)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .scrollIndicators(.hidden)
        .overlay(alignment: .top, content: {
            Button {
                navigationVM.backToPreviousPage()
            } label: {
                Image("back")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .frame(width: 30, height: 30)
            .padding(.top, 36)
            .padding(.leading, -366)
        })
        
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    @State var nav = NavigationViewModel()
    return NavigationView {
        InformationView( navigationVM: nav)
    }
}
