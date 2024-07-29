//
//  AnalysisDiamondViewModel.swift
//  Cuevision
//
//  Created by Fachmi Dimas Ardhana on 23/07/24.
//

import Foundation

@Observable
class AnalysisDiamondViewModel {
    var targetBallCoordinate: CGPoint = .zero
    var cueBallCoordinate: CGPoint = .zero
    var aimCoordinate: CGPoint = .zero
    
    var widthPoolBoundary: CGFloat = 0.0
    var heightPoolBoundary: CGFloat = 0.0
    
    func calculateAimCoordinate() -> Double {
        return ((targetBallCoordinate.x - cueBallCoordinate.x)/2) + cueBallCoordinate.x
    }
    
    func calculateReflectionPoint(cueBall: CGPoint, targetBall: CGPoint) -> CGPoint {
        let reflectionX = ((targetBall.x - cueBall.x) / 2) + cueBall.x
        let reflectionY: CGFloat
        let rX = reflectionX - (widthPoolBoundary/2)
        let rY:CGFloat
        
        let y1: CGFloat = heightPoolBoundary // titik y tertinggi
        let y2: CGFloat = 0 // titik y terendah
        
        if abs(cueBall.y - y2) < abs(cueBall.y - y1) && abs(targetBall.y - y2) < abs(targetBall.y - y1) {
            reflectionY = y2
            rY = (reflectionY - (heightPoolBoundary/2))
        } else {
            reflectionY = y1
            rY = (reflectionY - (heightPoolBoundary/2))
        }
        
        return CGPoint(x: rX, y: rY)
    }
    
    func findPointTranslation(from point: CGPoint, widthPoolBoundary: CGFloat, heightPoolBoundary: CGFloat, sizeBall: CGFloat) -> CGPoint {
        let _ = sizeBall/2
        let xTranslation = point.x + (widthPoolBoundary/2)
        let yTranslation = abs(point.y - (heightPoolBoundary/2))
        return CGPoint(x: xTranslation, y: yTranslation)
    }
    
}

extension CGFloat {
    func numberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }
    
    func formatterDouble() -> String {
        return numberFormatter().string(from: self as NSNumber) ?? "0"
    }
}

extension Double {
    func numberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }
    
    func formatterDouble() -> String {
        return numberFormatter().string(from: self as NSNumber) ?? "0"
    }
}

func convertToDiamondNumber() {
    var cueballPosition = 0
    var targetballPosition = 0
}
