//
//  CustomFont.swift
//  Cuevision
//
//  Created by Fachmi Dimas Ardhana on 17/07/24.
//

import Foundation
import SwiftUI

extension UIFont {
    var expanded: UIFont {
        let newDescriptor = fontDescriptor.withSymbolicTraits(.traitExpanded) ?? fontDescriptor
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }
}

extension Font {
    static func expandedFont(size: CGFloat) -> Font {
        let uiFont = UIFont.systemFont(ofSize: size).expanded
        return Font(uiFont)
    }
}
