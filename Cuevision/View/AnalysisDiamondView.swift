//
//  AnalysisDiamondView.swift
//  Cuevision
//
//  Created by Fachmi Dimas Ardhana on 17/07/24.
//

import SwiftUI

struct AnalysisDiamondView: View {
    var body: some View {
//        ZStack {
//            Image(systemName: "chevron.left")
//                .font(.largeTitle)
//        }
        
        VStack(alignment: .leading) {
            Text("How?").font(Font.custom("SFPro-ExpandedRegular", size: 30))
                .fontWeight(.bold)
                .padding(.bottom)
            
            Text("P = C - T")
                .fontWeight(.bold)
                .font(.title2)
            Text("P = Pocket")
            Text("C = Cueball Position")
            Text("T = Target Ball")
        }
        
    }
}

#Preview {
    AnalysisDiamondView()
}
