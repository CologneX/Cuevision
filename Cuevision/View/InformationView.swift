//
//  InformationView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 17/07/24.
//

import SwiftUI

struct InformationView: View {
    var body: some View {
        ZStack{
            Image("InfoBG")
            
            HStack{
                ScrollView {
                    VStack(alignment: .center, spacing: 10) {
                        Image("ball2")
                            .padding()
                        
                        Image("ball3")
                            .padding()
                        
                        Image("ball4")
                            .padding(.bottom)
                    }
                }
                
                VStack{
                    Text("Diamond System").font(Font.custom("SFPro-ExpandedBold", size: 40.0))
                        .font(.system(size: 50))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
//                                            .tracking(2)
                    
                    Text("learn how to aim more accurately using diamond system")
                        .font(.body)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    InformationView()
}
