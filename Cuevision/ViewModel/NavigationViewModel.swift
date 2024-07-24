//
//  NavigationViewModel.swift
//  Cuevision
//
//  Created by Fachmi Dimas Ardhana on 23/07/24.
//

import Foundation

@Observable
class NavigationViewModel {
    var path: [String] = []
    
    func goToNextPage(screenName: String) {
        path.append(screenName)
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
