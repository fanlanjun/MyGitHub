//
//  MyGitHubApp.swift
//  GitHubAPIService
//
//  Created by Frank Fan on 2026/3/20.
//

import Foundation
import Alamofire

enum GitHubError: Error {
    case invalidResponse
    case unauthorized
    case networkError
}

class GitHubAPIService: GitHubAPIProtocol {
    static let shared = GitHubAPIService()
    private let baseURL = "https://api.github.com"
    
    private init() {}
    
    private let defaultHeaders: HTTPHeaders = [
        "Accept": "application/vnd.github.v3+json", // 强制指定 v3 版本
        "User-Agent": "GitHubiOS-Client" // 必须设置，否则 API 会拒绝请求
    ]
    
    func fetchTrendingRepos(completion: @escaping (Result<[Repo], GitHubError>) -> Void) {
        let url = "\(baseURL)/search/repositories?q=stars:>1000&sort=stars&order=desc"
        
        var headers = defaultHeaders
        if (!AuthService.shared.getToken().isEmpty) {
            headers.add(HTTPHeader(name: "Authorization", value: "token \(AuthService.shared.getToken())"))
        }
        
        AF.request(url, headers: headers).responseDecodable(of: RepoSearchResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.items))
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    func searchRepos(query: String, completion: @escaping (Result<[Repo], GitHubError>) -> Void) {
        let url = "\(baseURL)/search/repositories?q=\(query)"
        
        var headers = defaultHeaders
        headers.add(HTTPHeader(name: "Authorization", value: "token \(AuthService.shared.getToken())"))
        
        AF.request(url, headers: headers).responseDecodable(of: RepoSearchResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.items))
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    func fetchUserProfile(username: String, completion: @escaping (Result<User, GitHubError>) -> Void) {
        let url = "\(baseURL)/user"
        
        var headers = defaultHeaders
        headers.add(HTTPHeader(name: "Authorization", value: "token \(AuthService.shared.getToken())"))
        
        AF.request(url, headers: headers).responseDecodable(of: User.self) { response in
            switch response.result {
            case .success(let user):
                completion(.success(user))
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    func Login(username: String, auth: String, completion: @escaping (Result<User, GitHubError>) -> Void) {
        let url = "\(baseURL)/user"
        
        var headers = defaultHeaders
        headers.add(HTTPHeader(name: "Authorization", value: "token \(auth)"))
        
        AF.request(url, headers: headers).responseDecodable(of: User.self) { response in
            switch response.result {
            case .success(let user):
                completion(.success(user))
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
}

// 数据模型
struct RepoSearchResponse: Decodable {
    let items: [Repo]
}

struct Repo: Decodable, Identifiable {
    let id: Int                     // 仓库 ID
    let name: String                // 仓库名
    let fullName: String            // 完整名称（用户名/仓库名）
    let description: String?        // 仓库描述
    let htmlUrl: String             // 仓库 URL
    let stargazersCount: Int        // 星标数
    let owner: User                 // 仓库所有者
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case fullName = "full_name"
        case description
        case htmlUrl = "html_url"
        case stargazersCount = "stargazers_count"
        case owner
    }
}

struct User: Decodable, Identifiable {
    let id: Int
    let login: String
    let avatar_url: String
    let name: String?
    let bio: String?
    let public_repos: Int?
    let followers: Int?
    let following: Int?
}
