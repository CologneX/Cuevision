//
//  AnalysisDiamondView.swift
//  Cuevision
//
//  Created by Fachmi Dimas Ardhana on 17/07/24.
//

import SwiftUI

struct AnalysisDiamondView: View {
    @State private var aim = 0.0
    @State private var cueballPosition = 0.0
    @State private var targetBallPosition = 0.0
    
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
                
                Text("P = C - T")
                    .fontWeight(.bold)
                    .font(.title2)
                    .foregroundColor(.black)
                Text("P = Pocket")
                    .foregroundColor(.grayA2)
                Text("C = Cueball Position")
                    .foregroundColor(.grayA2)
                Text("T = Target Ball")
                    .foregroundColor(.grayA2)
                
                RoundedRectangle(cornerRadius: 52, style: .continuous)
                    .fill(.darkGreen)
                    .frame(maxWidth: 200, maxHeight: 70)
                    .overlay {
                        let finalAim = cueballPosition - targetBallPosition
                        Text("\(numberFormatter.string(for: finalAim) ?? "0") = \(numberFormatter.string(for: cueballPosition) ?? "0") - \(numberFormatter.string(for: targetBallPosition) ?? "0")")
                            .foregroundStyle(.white)
                            .fontWeight(.medium)
                            .font(.title2)
                    }
                    .padding(.top, 48)
                
                Spacer()
            }
            .padding(.horizontal, 48)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .ignoresSafeArea()
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }()
}

#Preview {
    AnalysisDiamondView()
}
