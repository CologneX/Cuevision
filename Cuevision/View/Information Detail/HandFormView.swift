//
//  HandFormView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 23/07/24.
//

import SwiftUI

struct HandFormView: View {
//    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            GeometryReader(content: { geometry in
                Image("InfoBG")
                Image("InfoBall2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:geometry.size.height)
            })
            
            VStack{
                Text("Hand Form").font(Font.custom("SFPro-ExpandedBold", size: 40.0))
                    .foregroundColor(.white)
                Spacer()
                Image("InfoHandForm")
                
            }
            .padding(.leading, 200)
            .padding(.vertical, 40)
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HandFormView()
}
