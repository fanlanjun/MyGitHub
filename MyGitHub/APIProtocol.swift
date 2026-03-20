//
//  MyGitHubApp.swift
//  APIProtocol
//
//  Created by Frank Fan on 2026/3/20.
//

import LocalAuthentication

protocol AuthServiceProtocol {
    func login(username: String, password: String, completion: @escaping (Bool) -> Void)
    func logout()
    func biometricLogin(completion: @escaping (Bool) -> Void)
    func isLoggedIn() -> Bool
    func getCurrentUser() -> String?
}

protocol GitHubAPIProtocol {
    func Login(username: String, auth: String, completion: @escaping (Result<User, GitHubError>) -> Void)
    func fetchTrendingRepos(completion: @escaping (Result<[Repo], GitHubError>) -> Void)
    func searchRepos(query: String, completion: @escaping (Result<[Repo], GitHubError>) -> Void)
    func fetchUserProfile(username: String, completion: @escaping (Result<User, GitHubError>) -> Void)
}

protocol SecureStorageProtocol {
    func set(_ value: String, forKey key: String) throws
    func get(forKey key: String) -> String?
    func remove(forKey key: String) throws
    func removeAll() throws
}
