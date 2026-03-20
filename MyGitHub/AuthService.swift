//
//  MyGitHubApp.swift
//  AuthService
//
//  Created by Frank Fan on 2026/3/20.
//

import Foundation
import KeychainSwift
import LocalAuthentication


class AuthService: AuthServiceProtocol {
    static let shared = AuthService()
    private let keychain = KeychainStorage()
    private let userDefaults = UserDefaults.standard
    private let loggedInKey = "isLoggedIn"
    private let currentUserKey = "currentUser"
    private var userToken = ""
    
    private init() {}
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        try? keychain.set(username, forKey: "username")
        try? keychain.set(password, forKey: "authtoken")
        userDefaults.set(true, forKey: loggedInKey)
        userDefaults.set(username, forKey: currentUserKey)
        userToken = password
        completion(true)
    }
    
    func getToken() -> String {
        return userToken
    }
    
    func logout() {
        userToken = ""
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
            if success, let username = self.keychain.get(forKey: "username") {
                self.userDefaults.set(true, forKey: self.loggedInKey)
                self.userDefaults.set(username, forKey: self.currentUserKey)
                self.userToken = self.keychain.get(forKey: "authtoken") ?? ""
            }
            completion(success)
        }
    }
    
    func isLoggedIn() -> Bool {
        return !userToken.isEmpty
    }
    
    func getCurrentUser() -> String? {
        userDefaults.string(forKey: currentUserKey)
    }
}
