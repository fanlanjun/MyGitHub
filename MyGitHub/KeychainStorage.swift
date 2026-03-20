//
//  MyGitHubApp.swift
//  KeychainStorage
//
//  Created by Frank Fan on 2026/3/20.
//

import KeychainSwift

class KeychainStorage: SecureStorageProtocol {
    private let keychain = KeychainSwift()
    
    init() {
        keychain.accessGroup = "com.frank.MyGitHub"
        keychain.synchronizable = true
    }
    
    func set(_ value: String, forKey key: String) throws {
        guard keychain.set(value, forKey: key) else {
            throw StorageError.failedToSet
        }
    }
    
    func get(forKey key: String) -> String? {
        keychain.get(key)
    }
    
    func remove(forKey key: String) throws {
        guard keychain.delete(key) else {
            throw StorageError.failedToRemove
        }
    }
    
    func removeAll() throws {
        keychain.allKeys.forEach { key in
            keychain.delete(key)
        }
    }
}

enum StorageError: LocalizedError {
    case failedToSet, failedToRemove
    
    var errorDescription: String? {
        switch self {
        case .failedToSet: return NSLocalizedString("存储凭证失败", comment: "")
        case .failedToRemove: return NSLocalizedString("移除凭证失败", comment: "")
        }
    }
}
