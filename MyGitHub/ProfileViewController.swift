//
//  MyGitHubApp.swift
//  ProfileViewController
//
//  Created by Frank Fan on 2026/3/20.
//

import UIKit
import SnapKit
import Kingfisher
import SVProgressHUD

class ProfileViewController: UIViewController {
    
    // MARK: - UI Components
    private let avatarImageView = RoundedImageView(frame: CGRect.zero)
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let bioLabel = UILabel()
    private let reposCountLabel = UILabel()
    private let followersLabel = UILabel()
    private let followingLabel = UILabel()
    private let logoutButton = UIButton(type: .system)
    
    // MARK: - Services
    private let auth = AuthService.shared
    private let api = GitHubAPIService.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("profile_title", comment: "Profile screen title")
        setupUI()
        loadUserInfo()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Avatar Image View
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.backgroundColor = .systemGray5 // Placeholder background
        
        // Name Label
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.textColor = .label // Dynamic color for dark/light mode
        
        // Login Label
        loginLabel.font = .systemFont(ofSize: 16)
        loginLabel.textColor = .secondaryLabel // Dynamic color
        
        // Bio Label
        bioLabel.font = .systemFont(ofSize: 15)
        bioLabel.numberOfLines = 0
        bioLabel.textColor = .tertiaryLabel // Dynamic color
        
        // Info Labels (Repos, Followers, Following)
        [reposCountLabel, followersLabel, followingLabel].forEach { label in
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .center
            label.numberOfLines = 2
            label.textColor = .label // Dynamic color
        }
        
        // Info Stack View
        let infoStack = UIStackView(arrangedSubviews: [reposCountLabel, followersLabel, followingLabel])
        infoStack.axis = .horizontal
        infoStack.spacing = 16
        infoStack.distribution = .fillEqually
        
        // Logout Button
        logoutButton.setTitle(NSLocalizedString("logout_button", comment: "Logout button title"), for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        // Main Stack View
        let stack = UIStackView(arrangedSubviews: [avatarImageView, nameLabel, loginLabel, bioLabel, infoStack, logoutButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center // Center align all items
        view.addSubview(stack)
        
        // Layout Constraints
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        
        stack.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        // Add spacing to logout button
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(infoStack.snp.bottom).offset(24)
        }
    }
    
    // MARK: - Data Loading
    private func loadUserInfo() {
        guard let username = auth.getCurrentUser() else {
            showError(message: NSLocalizedString("error_no_user", comment: "Error message when no user is logged in"))
            return
        }
        
        // Show loading indicator
        SVProgressHUD.show()
        
        api.fetchUserProfile(username: username) { [weak self] result in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.updateUI(user: user)
            case .failure(let error):
                self.showError(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - UI Update
    private func updateUI(user: User) {
        nameLabel.text = user.name ?? user.login
        loginLabel.text = "@\(user.login)"
        bioLabel.text = user.bio ?? NSLocalizedString("no_bio", comment: "Text when user has no bio")
        reposCountLabel.text = "\(NSLocalizedString("repos", comment: "Repositories"))\n\(user.public_repos ?? 0)"
        followersLabel.text = "\(NSLocalizedString("followers", comment: "Followers"))\n\(user.followers ?? 0)"
        followingLabel.text = "\(NSLocalizedString("following", comment: "Following"))\n\(user.following ?? 0)"
        
        // Load avatar image with Kingfisher
        avatarImageView.kf.setImage(
            with: URL(string: user.avatar_url),
            placeholder: UIImage(systemName: "person.circle.fill")?.withTintColor(.systemGray3),
            options: [.transition(.fade(0.2))]
        )
    }
    
    // MARK: - Actions
    @objc private func logoutTapped() {
        let alert = UIAlertController(
            title: NSLocalizedString("logout_confirm_title", comment: "Logout confirmation alert title"),
            message: NSLocalizedString("logout_confirm_message", comment: "Logout confirmation alert message"),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "Cancel button"), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("logout", comment: "Logout button"), style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    private func performLogout() {
        auth.logout()
        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
    }
    
    // MARK: - Error Handling
    private func showError(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("error_title", comment: "Error alert title"),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "OK button"), style: .default))
        present(alert, animated: true)
    }
}
