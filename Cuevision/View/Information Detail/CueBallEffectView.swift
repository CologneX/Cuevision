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
        NavigationStack{
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("BackCross")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                    }
                    .padding(.top, 30)
                }
            }
            .padding(.all, -20)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    CueBallEffectView()
}
