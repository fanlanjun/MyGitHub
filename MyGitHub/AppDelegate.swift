//
//  AppDelegate.swift
//  MyGitHub
//
//  Created by Frank Fan on 20/3/2026.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        
        window?.rootViewController = MainTabBarController()
        
        window?.makeKeyAndVisible()
        return true
    }
}
