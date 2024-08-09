//
//  HandFormView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 23/07/24.
//

import SwiftUI

struct HandFormView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            GeometryReader(content: { geometry in
                Image("InfoBG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                Image("InfoBall2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:geometry.size.height)
                
                VStack{
                    Text("Hand Form").font(Font.custom("SFPro-ExpandedBold", fixedSize: 40.0))
                        .foregroundColor(.white)
                    Image("InfoHandForm")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 245)
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
    HandFormView()
}
