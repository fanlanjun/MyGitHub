import UIKit
import SnapKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    private let avatarImageView = RoundedImageView()
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let bioLabel = UILabel()
    private let reposCountLabel = UILabel()
    private let followersLabel = UILabel()
    private let followingLabel = UILabel()
    
    private let auth = AuthService.shared
    private let api = GitHubAPIService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "我的"
        setupUI()
        loadUserInfo()
    }
    
    private func setupUI() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 50
        view.addSubview(avatarImageView)
        
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        loginLabel.font = .systemFont(ofSize: 16)
        loginLabel.textColor = .secondaryLabel
        
        bioLabel.font = .systemFont(ofSize: 15)
        bioLabel.numberOfLines = 0
        bioLabel.textColor = .tertiaryLabel
        
        let infoStack = UIStackView(arrangedSubviews: [reposCountLabel, followersLabel, followingLabel])
        infoStack.axis = .horizontal
        infoStack.spacing = 16
        infoStack.distribution = .fillEqually
        
        let stack = UIStackView(arrangedSubviews: [avatarImageView, nameLabel, loginLabel, bioLabel, infoStack])
        stack.axis = .vertical
        stack.spacing = 12
        view.addSubview(stack)
        
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        
        stack.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func loadUserInfo() {
        guard let username = auth.getCurrentUser() else { return }
        
        api.fetchUserProfile(username: username) { [weak self] result in
            switch result {
            case .success(let user):
                self?.updateUI(user: user)
            case .failure:
                break
            }
        }
    }
    
    private func updateUI(user: User) {
        nameLabel.text = user.name ?? user.login
        loginLabel.text = user.login
        bioLabel.text = user.bio ?? "暂无简介"
        reposCountLabel.text = "仓库\n\(user.public_repos)"
        followersLabel.text = "粉丝\n\(user.followers)"
        followingLabel.text = "关注\n\(user.following)"
        
        avatarImageView.setImage(with: URL(string: user.avatar_url))
    }
}
