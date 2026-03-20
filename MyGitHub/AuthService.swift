import Foundation
import KeychainAccess
import LocalAuthentication

protocol AuthServiceProtocol {
    func login(username: String, password: String, completion: @escaping (Bool) -> Void)
    func logout()
    func biometricLogin(completion: @escaping (Bool) -> Void)
    func isLoggedIn() -> Bool
    func getCurrentUser() -> String?
}

class AuthService: AuthServiceProtocol {
    static let shared = AuthService()
    private let keychain = Keychain(service: "com.githubapp")
    private let userDefaults = UserDefaults.standard
    private let loggedInKey = "isLoggedIn"
    private let currentUserKey = "currentUser"
    
    private init() {}
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        // 模拟 GitHub 登录验证
        keychain["username"] = username
        keychain["password"] = password
        userDefaults.set(true, forKey: loggedInKey)
        userDefaults.set(username, forKey: currentUserKey)
        completion(true)
    }
    
    func logout() {
        try? keychain.removeAll()
        userDefaults.set(false, forKey: loggedInKey)
        userDefaults.removeObject(forKey: currentUserKey)
    }
    
    func biometricLogin(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false)
            return
        }
        
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: NSLocalizedString("biometric_reason", comment: "")
        ) { success, _ in
            if success, let username = self.keychain["username"] {
                self.userDefaults.set(true, forKey: self.loggedInKey)
                self.userDefaults.set(username, forKey: self.currentUserKey)
            }
            completion(success)
        }
    }
    
    func isLoggedIn() -> Bool {
        userDefaults.bool(forKey: loggedInKey)
    }
    
    func getCurrentUser() -> String? {
        userDefaults.string(forKey: currentUserKey)
    }
}
