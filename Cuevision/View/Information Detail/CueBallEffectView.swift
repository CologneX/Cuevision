//
//  CueBallEffectView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 22/07/24.
//

import SwiftUI

struct CueBallEffectView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            GeometryReader(content: { geometry in
                Image("InfoBG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                Image("InfoBall1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:geometry.size.height)
            })
            
            VStack{
                Text("Cue Ball Effect").font(Font.custom("SFPro-ExpandedBold", size: 40.0))
                    .foregroundColor(.white)
                Image("InfoCueBallEffect")
            }
            .padding(.leading, 200)
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
    CueBallEffectView()
}
