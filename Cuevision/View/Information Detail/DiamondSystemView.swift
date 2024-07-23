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
        NavigationStack{
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
                })
                
                VStack{
                    Text("Diamond System").font(Font.custom("SFPro-ExpandedBold", size: 40.0))
                        .foregroundColor(.white)
                    Spacer()
                    Image("InfoDiamondSystem")
                }
                .padding(.leading, 320)
                .padding(.vertical, 70)
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
    DiamondSystemView()
}
