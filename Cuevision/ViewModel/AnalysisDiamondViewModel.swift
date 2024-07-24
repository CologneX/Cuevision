//
//  AnalysisDiamondViewModel.swift
//  Cuevision
//
//  Created by Fachmi Dimas Ardhana on 23/07/24.
//

import Foundation

@Observable
class AnalysisDiamondViewModel {
    var targetBallCoordinate = 0.0
    var cueBallCoordinate = 0.0
    var aimCoordinate = 0.0
    var widthPoolBoundary2: CGFloat = 0.0
    var heightPoolBoundary2: CGFloat = 0.0
    
    func calculateAimCoordinate() -> Double {
        return ((targetBallCoordinate - cueBallCoordinate)/2) + cueBallCoordinate
    }
    
    func findPointTranslation(from point: CGPoint, widthPoolBoundary: CGFloat, heightPoolBoundary: CGFloat) -> CGPoint {
        let xTranslation = point.x + (widthPoolBoundary/2)
        let yTranslation = point.y + (heightPoolBoundary/2)
        return CGPoint(x: xTranslation, y: yTranslation)
    }
}
