// Sources/Core/Storage/KeychainStorage.swift
import KeychainSwift

class KeychainStorage: SecureStorageProtocol {
    private let keychain = KeychainSwift()
    
    init() {
        keychain.accessGroup = "com.xxx.GitHubiOS" // 替换为团队 ID
        keychain.synchronizable = true // 支持 iCloud 同步
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
}

// 存储错误枚举
enum StorageError: LocalizedError {
    case failedToSet, failedToRemove
    
    var errorDescription: String? {
        switch self {
        case .failedToSet: return NSLocalizedString("存储凭证失败", comment: "")
        case .failedToRemove: return NSLocalizedString("移除凭证失败", comment: "")
        }
    }
}
