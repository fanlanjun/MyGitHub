// Sources/Core/Protocols/AuthProtocol.swift
import LocalAuthentication

/// 认证服务协议（解耦登录/登出/生物识别）
protocol AuthServiceProtocol {
    func saveCredentials(username: String, password: String) throws
    func getCredentials() -> (username: String?, password: String?)
    func logout() throws
    func authenticateWithBiometrics(completion: @escaping (Result<Bool, Error>) -> Void)
    func isBiometricsAvailable() -> Bool
}

/// GitHub API 协议（解耦接口调用）
protocol GitHubAPIServiceProtocol {
    func fetchUserProfile(username: String, completion: @escaping (Result<UserModel, APIError>) -> Void)
    func fetchTrendingRepos(completion: @escaping (Result<[RepoModel], APIError>) -> Void)
    func search(query: String, type: SearchType, completion: @escaping (Result<[SearchResultModel], APIError>) -> Void)
}

/// 安全存储协议（解耦 Keychain 实现）
protocol SecureStorageProtocol {
    func set(_ value: String, forKey key: String) throws
    func get(forKey key: String) -> String?
    func remove(forKey key: String) throws
}
