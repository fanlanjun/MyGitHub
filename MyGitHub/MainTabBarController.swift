//
//  MainTabBarController.swift
//  MyGitHub
//
//  Created by Frank Fan on 20/3/2026.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let home = HomeViewController()
        
        self.delegate = self
        
        home.tabBarItem = UITabBarItem(
            title: "首页",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        let homeNav = UINavigationController(rootViewController: home)
        
        let search = SearchViewController()
        search.tabBarItem = UITabBarItem(
            title: "搜索",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
        let searchNav = UINavigationController(rootViewController: search)
        
        let profile = ProfileViewController()
        profile.tabBarItem = UITabBarItem(
            title: "我的",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        let profileNav = UINavigationController(rootViewController: profile)
        
        viewControllers = [homeNav, searchNav, profileNav]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        let isLogin = AuthService.shared.isLoggedIn()
        
        if (index == 1 || index == 2) && !isLogin {
            showLoginPage()
            return false
        }
        
        return true
    }
    
    private func showLoginPage() {
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
        
    }
}
