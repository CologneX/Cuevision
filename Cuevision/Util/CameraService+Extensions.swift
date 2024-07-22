//
//  CameraPreview.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 18/07/24.
//

import Foundation
import UIKit
import AVFoundation

//extension AVCaptureVideoOrientation {
//    init?(deviceOrientation: UIDeviceOrientation) {
//        switch deviceOrientation {
//        case .portrait: self = .portrait
//        case .portraitUpsideDown: self = .portraitUpsideDown
//        case .landscapeLeft: self = .landscapeRight
//        case .landscapeRight: self = .landscapeLeft
//        default: return nil
//        }
//    }
//    
//    init?(interfaceOrientation: UIInterfaceOrientation) {
//        switch interfaceOrientation {
//        case .portrait: self = .portrait
//        case .portraitUpsideDown: self = .portraitUpsideDown
//        case .landscapeLeft: self = .landscapeLeft
//        case .landscapeRight: self = .landscapeRight
//        default: return nil
//        }
//    }
//}

extension AVCaptureDevice.DiscoverySession {
    var uniqueDevicePositionsCount: Int {
        
        var uniqueDevicePositions = [AVCaptureDevice.Position]()
        
        for device in devices where !uniqueDevicePositions.contains(device.position) {
            uniqueDevicePositions.append(device.position)
        }
        
        return uniqueDevicePositions.count
    }
}


//extension AVCaptureDevice.RotationCoordinator {
//    public override convenience init() {
////        self.init(device: <#T##AVCaptureDevice#>, previewLayer: <#T##CALayer?#>)
//        self.init()
//        print(self.videoRotationAngleForHorizonLevelCapture)
//
//    }
//}
