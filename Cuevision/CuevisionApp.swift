//
//  CuevisionApp.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 12/07/24.
//

import SwiftUI

@main
struct CuevisionApp: App {
    // AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
//            CueBallEffectView()
            HomeView()
        }
    }
}
