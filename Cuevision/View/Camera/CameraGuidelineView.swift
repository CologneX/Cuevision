//
//  CameraGuidelineView.swift
//  Cuevision
//
//  Created by Fachmi Dimas Ardhana on 30/07/24.
//

import SwiftUI

struct CameraGuidelineView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment:.leading) {
            HStack(alignment:.top) {
                Button {
                    dismiss()
                } label: {
                    Image(.backCrossGreen)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .fontWeight(.bold)
                        .frame(height: 48)
                }
                .buttonBorderShape(.circle)
                .tint(.white)
                .padding(.top, -12)
                
                VStack {
                    Text("Follow these guidelines for an optimal setup and enjoy your game!")
                        .font(Font.custom("SFPro-ExpandedBold", fixedSize: 16.0))
                        .foregroundStyle(.darkGreen)
                    
                    Image(.cameraGuideline)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                        .padding(.vertical)
                    
                    Text("1. Visibility Check")
                        .fontWeight(.heavy)
                        .foregroundStyle(.darkGreen)
                    Text("Ensure the balls, cue, and pockets are visible within the frame.")
                        .fontWeight(.medium)
                        .padding(.bottom)
                        .foregroundStyle(.darkGreen)
                    Text("2. Clear Angle")
                        .fontWeight(.heavy)
                        .foregroundStyle(.darkGreen)
                    Text("Make sure the angle of your shot is clear and unobstructed.")
                        .fontWeight(.medium)
                        .foregroundStyle(.darkGreen)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white) // Background color
        .cornerRadius(20) // Corner radius
        .shadow(radius: 10) // Optional: Adding a shadow
    }
}

#Preview {
    CameraGuidelineView()
}
