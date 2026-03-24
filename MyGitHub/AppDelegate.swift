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
        
        let testVC = UIViewController()
        testVC.view.backgroundColor = .white
        let label = UILabel()
        label.text = "Hello World"
        label.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        testVC.view.addSubview(label)
        
        window?.rootViewController = testVC
        window?.makeKeyAndVisible()
        
        print("✅ App launched successfully")

        
//        window?.rootViewController = MainTabBarController()
        
        window?.makeKeyAndVisible()
        return true
    }
}
