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
        let y1: CGFloat = 55.0
        let y2: CGFloat = 315.0
        
        // Tentukan titik pantul berdasarkan kedekatan dengan y1 atau y2
        if abs(cueBall.y - y2) < abs(cueBall.y - y1) && abs(targetBall.y - y2) < abs(targetBall.y - y1) {
            reflectionY = y1
        } else {
            reflectionY = y2
        }
        
        return CGPoint(x: reflectionX, y: reflectionY)
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
