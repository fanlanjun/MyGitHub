//
//  MyGitHubApp.swift
//  HomeViewController
//
//  Created by Frank Fan on 2026/3/20.
//

import UIKit
import Kingfisher
import MJRefresh
import SnapKit
import SVProgressHUD

class HomeViewController: UIViewController {
    private let tableView = UITableView()
    private var repos: [Repo] = []
    private let apiService: GitHubAPIProtocol
    
    init(apiService: GitHubAPIProtocol = GitHubAPIService.shared) {
        self.apiService = apiService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        fetchTrendingRepos()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("主页", comment: "")
        view.addSubview(tableView)
        
        // 布局
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // 注册 Cell
        tableView.register(RepoCell.self, forCellReuseIdentifier: RepoCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.fetchTrendingRepos()
        })
    }
    
    // 获取趋势仓库（GitHub API）
    private func fetchTrendingRepos() {
        SVProgressHUD.show()
        apiService.fetchTrendingRepos { [weak self] result in
            
            SVProgressHUD.dismiss()
            
            guard let self = self else { return }
            self.tableView.mj_header?.endRefreshing()
            
            switch result {
            case .success(let repos):
                self.repos = repos
                self.tableView.reloadData()
            case .failure(let error):
                // 跳转通用错误页
                let errorVC = ErrorViewController()
                errorVC.configure(with: error)
//                errorVC.retryAction = { [weak self] in
//                    self?.fetchTrendingRepos()
//                }
                self.navigationController?.pushViewController(errorVC, animated: true)
            }
        }
    }
}

// MARK: - TableView 代理
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.reuseID, for: indexPath) as! RepoCell
        cell.configure(with: repos[indexPath.row])
        return cell
    }
}

// MARK: - 仓库 Cell
class RepoCell: UITableViewCell {
    static let reuseID = "RepoCell"
    
    private let avatarIV = UIImageView()
    private let nameLabel = UILabel()
    private let descLabel = UILabel()
    private let starLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descLabel.font = UIFont.systemFont(ofSize: 14)
        self.starLabel.font = UIFont.systemFont(ofSize: 12)
        
        avatarIV.layer.cornerRadius = 20
        avatarIV.clipsToBounds = true
        avatarIV.contentMode = .scaleAspectFill
        
        // 布局
        let stack = UIStackView(arrangedSubviews: [nameLabel, descLabel, starLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        contentView.addSubview(avatarIV)
        contentView.addSubview(stack)
        
        avatarIV.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarIV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarIV.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarIV.widthAnchor.constraint(equalToConstant: 40),
            avatarIV.heightAnchor.constraint(equalToConstant: 40),
            
            stack.leadingAnchor.constraint(equalTo: avatarIV.trailingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with repo: Repo) {
        nameLabel.text = repo.name
        descLabel.text = repo.description ?? NSLocalizedString("无描述", comment: "")
        avatarIV.kf.setImage(
            with: URL(string: repo.owner.avatar_url),
            placeholder: UIImage(systemName: "person.circle.fill")
        )
    }
}
