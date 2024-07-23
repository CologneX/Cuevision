//
//  DiamondSystemView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 23/07/24.
//

import SwiftUI

struct DiamondSystemView: View {
//    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            GeometryReader(content: { geometry in
                Image("InfoBG")
                Image("InfoBall3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:geometry.size.height)
            })
            
            VStack{
                Text("Diamond System").font(Font.custom("SFPro-ExpandedBold", size: 40.0))
                    .foregroundColor(.white)
                Spacer()
                Image("InfoDiamondSystem")
            }
            .padding(.vertical, 30)
            .padding(.leading, 300)
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DiamondSystemView()
}
