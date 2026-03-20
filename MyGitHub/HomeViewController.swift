// Sources/Features/Home/HomeViewController.swift
import UIKit
import Kingfisher
import MJRefresh

class HomeViewController: UIViewController {
    private let tableView = UITableView()
    private var repos: [RepoModel] = []
    private let apiService: GitHubAPIServiceProtocol
    
    init(apiService: GitHubAPIServiceProtocol = GitHubAPIService()) {
        self.apiService = apiService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchTrendingRepos()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("主页", comment: "")
        view.addSubview(tableView)
        
        // 布局
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.edges.equalTo(view.safeAreaLayoutGuide)
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
        apiService.fetchTrendingRepos { [weak self] result in
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
                errorVC.retryAction = { [weak self] in
                    self?.fetchTrendingRepos()
                }
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
    private let nameLabel = UILabel(font: .boldSystemFont(ofSize: 16))
    private let descLabel = UILabel(font: .systemFont(ofSize: 14), lines: 2)
    private let starLabel = UILabel(font: .systemFont(ofSize: 12), color: .tertiaryLabel)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        // 头像配置
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
    
    func configure(with repo: RepoModel) {
        nameLabel.text = repo.name
        descLabel.text = repo.description ?? NSLocalizedString("无描述", comment: "")
        starLabel.text = NSLocalizedString("星标数: \(repo.stargazersCount)", comment: "")
        avatarIV.kf.setImage(with: URL(string: repo.owner.avatarUrl))
    }
}

// MARK: - Label 扩展
extension UILabel {
    convenience init(font: UIFont, color: UIColor
