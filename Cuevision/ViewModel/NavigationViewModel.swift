//
//  NavigationViewModel.swift
//  Cuevision
//
//  Created by Fachmi Dimas Ardhana on 23/07/24.
//

import Foundation

enum NavigationPaths: String, Hashable {
    case CameraView
    case CueBallView
    case HandFormView
    case DiamondView
    case InformationView
}

class NavigationViewModel: ObservableObject {
    @Published var path: [NavigationPaths] = []
    
    func goToNextPage(_ view: NavigationPaths) {
        path.append(view)
    }
    
    func goToFirstScreen(){
        path.removeAll()
    }
    
    func backToPreviousPage() {
        if path.count > 0 {
            path.removeLast()
        }
    }
}
