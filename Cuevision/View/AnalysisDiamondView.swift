//
//  AnalysisDiamondView.swift
//  Cuevision
//
//  Created by Fachmi Dimas Ardhana on 17/07/24.
//

import SwiftUI

struct AnalysisDiamondView: View {
    @Binding var analysisDiamondVM: AnalysisDiamondViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 20, style: .circular)
                .fill(.white)
                .frame(maxWidth: 100, maxHeight: 80)
                .overlay {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.darkGreen)
                        .padding(.trailing, 48)
                        .offset(x:-5)
                }
                .offset(x: 64, y: -110)
            
            VStack(alignment: .leading) {
                Spacer()
                Text("How?").font(Font.custom("SFPro-ExpandedRegular", size: 30))
                    .fontWeight(.bold)
                    .padding(.bottom)
                    .foregroundColor(.black)
                
                Text("A = (T - C)/2 + C")
                    .fontWeight(.bold)
                    .font(.title2)
                    .foregroundColor(.black)
                Text("A = Aim")
                    .foregroundColor(.grayA2)
                    .padding(.top, 2)
                Text("C = Cueball Position")
                    .foregroundColor(.grayA2)
                Text("T = Target Ball")
                    .foregroundColor(.grayA2)
                
                RoundedRectangle(cornerRadius: 52, style: .continuous)
                    .fill(.darkGreen)
                    .frame(maxHeight: 70)
                    .overlay {
                        let result = analysisDiamondVM.calculateAimCoordinate()
                        Text("\(result.formatterDouble()) = (\(analysisDiamondVM.targetBallCoordinate.x.formatterDouble()) - \(analysisDiamondVM.cueBallCoordinate.x.formatterDouble()))/2 + \(analysisDiamondVM.cueBallCoordinate.x.formatterDouble())")
                            .foregroundStyle(.white)
                            .fontWeight(.medium)
                            .font(.title2)
                            .padding()
                    }
                
                    .padding(.top, 48)
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .frame(maxWidth: 350)
            .padding(.horizontal, 24)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    @State var analysisDiamondVM = AnalysisDiamondViewModel()
    
    return AnalysisDiamondView(analysisDiamondVM: $analysisDiamondVM)
}
