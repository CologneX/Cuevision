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
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CueBallEffectView()
}
