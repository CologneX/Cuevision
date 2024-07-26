//
//  CameraView+Extentions.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 22/07/24.
//

import SwiftUI

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
