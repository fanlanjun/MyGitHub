import Foundation
import Alamofire

enum GitHubError: Error {
    case invalidResponse
    case unauthorized
    case networkError
}

protocol GitHubAPIProtocol {
    func fetchTrendingRepos(completion: @escaping (Result<[Repo], GitHubError>) -> Void)
    func searchRepos(query: String, completion: @escaping (Result<[Repo], GitHubError>) -> Void)
    func fetchUserProfile(username: String, completion: @escaping (Result<User, GitHubError>) -> Void)
}

class GitHubAPIService: GitHubAPIProtocol {
    static let shared = GitHubAPIService()
    private let baseURL = "https://api.github.com"
    
    private init() {}
    
    func fetchTrendingRepos(completion: @escaping (Result<[Repo], GitHubError>) -> Void) {
        let url = "\(baseURL)/search/repositories?q=stars:>1000&sort=stars&order=desc"
        AF.request(url).responseDecodable(of: RepoSearchResponse.self) { response in
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
        AF.request(url).responseDecodable(of: RepoSearchResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.items))
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    func fetchUserProfile(username: String, completion: @escaping (Result<User, GitHubError>) -> Void) {
        let url = "\(baseURL)/users/\(username)"
        AF.request(url).responseDecodable(of: User.self) { response in
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
    let id: Int
    let name: String
    let full_name: String
    let description: String?
    let stargazers_count: Int
    let language: String?
    let owner: User
}

struct User: Decodable, Identifiable {
    let id: Int
    let login: String
    let avatar_url: String
    let name: String?
    let bio: String?
    let public_repos: Int
    let followers: Int
    let following: Int
}
