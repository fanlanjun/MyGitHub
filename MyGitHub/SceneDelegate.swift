// SceneDelegate.swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let authService = AuthService.shared
        let rootVC: UIViewController
        
        if authService.isLoggedIn() {
            rootVC = UINavigationController(rootViewController: HomeViewController())
        } else {
            rootVC = UINavigationController(rootViewController: LoginViewController())
        }
        
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
    }
}
