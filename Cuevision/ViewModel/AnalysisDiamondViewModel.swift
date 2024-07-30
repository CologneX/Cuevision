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
    
    var aimPosition = AimPosition.bottom
    
    let diamondsTop = [
        CGPoint(x: 0, y: 275),
        CGPoint(x: 71.25, y: 275),
        CGPoint(x: 142.5, y: 275),
        CGPoint(x: 213.75, y: 275),
        CGPoint(x: 285, y: 275),
        CGPoint(x: 356.25, y: 275),
        CGPoint(x: 427.5, y: 275),
        CGPoint(x: 498.75, y: 275),
        CGPoint(x: 570, y: 275)
    ]
    
    let diamondsBottom = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 71.25, y: 0),
        CGPoint(x: 142.5, y: 0),
        CGPoint(x: 213.75, y: 0),
        CGPoint(x: 285, y: 0),
        CGPoint(x: 356.25, y: 0),
        CGPoint(x: 427.5, y: 0),
        CGPoint(x: 498.75, y: 0),
        CGPoint(x: 570, y: 0)
    ]
    
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
            // titik pantul di bawah
            reflectionY = y2
            rY = (reflectionY - (heightPoolBoundary/2))
            aimPosition = .bottom
        } else {
            // titik pantul di atas
            reflectionY = y1
            rY = (reflectionY - (heightPoolBoundary/2))
            aimPosition = .top
        }
        
        return CGPoint(x: rX, y: rY)
    }
    
    func findPointTranslation(from point: CGPoint, widthPoolBoundary: CGFloat, heightPoolBoundary: CGFloat) -> CGPoint {
        let xTranslation = point.x + (widthPoolBoundary/2)
        let yTranslation = abs(point.y - (heightPoolBoundary/2))
        return CGPoint(x: xTranslation, y: yTranslation)
    }
    
    func convertToDiamondNumber(cueball: CGPoint, targetball: CGPoint) -> (cueball: CGFloat, targetball: CGFloat, aim: CGFloat) {
        let xCushionRange: ClosedRange<CGFloat> = 0.0...widthPoolBoundary
        let xDiamondRange: ClosedRange<CGFloat> = 0.0...80.0
        
        let dCueball = convertRange(value: cueball.x, from: xCushionRange, to: xDiamondRange)
        let dTargetball = convertRange(value: targetball.x, from: xCushionRange, to: xDiamondRange)
        let dAim = ((dTargetball - dCueball)/2) + dCueball
        
        return (dCueball, dTargetball, dAim)
    }
    
    func convertRange(value: CGFloat, from originalRange: ClosedRange<CGFloat>, to targetRange: ClosedRange<CGFloat>) -> CGFloat {
        let minOrig = originalRange.lowerBound
        let maxOrig = originalRange.upperBound
        let minTarget = targetRange.lowerBound
        let maxTarget = targetRange.upperBound
        
        return ((value - minOrig) * (maxTarget - minTarget)) / (maxOrig - minOrig) + minTarget
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

enum AimPosition {
    case top, bottom, left, right
}
