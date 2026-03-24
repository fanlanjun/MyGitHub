//
//  AppDelegate.swift
//  MyGitHub
//
//  Created by Frank Fan on 20/3/2026.
//

import SwiftUI

@main
struct MyGitHubApp: App {
    var body: some Scene {
        WindowGroup {
            ViewControllerWrapper()
        }
    }
}

struct ViewControllerWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = MainTabBarController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
