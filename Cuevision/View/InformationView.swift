//
//  InformationView.swift
//  Cuevision
//
//  Created by Gabriela Bernice Handoko on 17/07/24.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
//        NavigationStack{
            ZStack{
                Image("InfoBG")
                
//                HStack{
                    ScrollView {
                        VStack(alignment: .center, spacing: 10) {
                            Image("information1")
                                .padding(.leading, 50)
                            
                            Image("information1")
                                .padding(.leading, 50)
                            
                            Image("information1")
                                .padding(.leading, 50)
                        }
                    }
                    
//                    VStack{
//                        Text("Diamond System").font(Font.custom("SFPro-ExpandedBold", size: 40.0))
//                            .font(.system(size: 50))
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
//                            .padding(.bottom, 5)
//                        //                                            .tracking(2)
//                        
//                        Text("learn how to aim more accurately using diamond system")
//                            .font(.body)
//                            .foregroundColor(.white)
//                    }
//                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }){
                            Image("back")
                        }
                        .padding(.top, 30)
                    }
                }
            }
//        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationView {
        InformationView()
    }
}
