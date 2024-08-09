//
//  DiamondSystemView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 23/07/24.
//

import SwiftUI

struct DiamondSystemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            GeometryReader(content: { geometry in
                Image("InfoBG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                Image("InfoBall3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:geometry.size.height)
                
                VStack {
                    Text("Diamond System").font(Font.custom("SFPro-ExpandedBold", fixedSize: 40.0))
                        .foregroundColor(.white)
                    Image("InfoDiamondSystem")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(maxHeight: .infinity)
                .padding(.all, 36)
                .padding(.leading, 280)
            })
        }
        .overlay(alignment: .topTrailing, content: {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("BackCross")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
            .padding(.top, 36)
            .padding(.trailing, 36)
        })
        .padding(.all, -20)
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DiamondSystemView()
}
