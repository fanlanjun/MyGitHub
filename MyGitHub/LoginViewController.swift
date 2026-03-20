//
//  MyGitHubApp.swift
//  LoginViewController
//
//  Created by Frank Fan on 2026/3/20.
//

import UIKit
import LocalAuthentication
import SVProgressHUD

class LoginViewController: UIViewController {
    
    private let usernameTF = UITextField(placeholder: "User name", isSecure: false)
    private let passwordTF = UITextField(placeholder: "Auth Token", isSecure: true)
    private let loginBtn = UIButton(title: "登录", bgColor: .systemBlue)
    private let biometricsBtn = UIButton(title: "生物识别登录", font: .systemFont(ofSize: 14))
    
    private let authService: AuthServiceProtocol
    private let apiService: GitHubAPIProtocol
    
    init(authService: AuthServiceProtocol = AuthService.shared,
         apiService: GitHubAPIProtocol = GitHubAPIService.shared) {
        self.authService = authService
        self.apiService = apiService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBiometrics()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("登录", comment: "")
        
        let stack = UIStackView(arrangedSubviews: [usernameTF, passwordTF, loginBtn, biometricsBtn])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // 按钮点击
        loginBtn.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        biometricsBtn.addTarget(self, action: #selector(biometricsTapped), for: .touchUpInside)
    }
    
    private func setupBiometrics() {
        biometricsBtn.isHidden = authService.getCurrentUser()?.isEmpty ?? true
    }
    
    // MARK: - 事件处理
    @objc private func loginTapped() {
        guard let username = usernameTF.text, !username.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
            showAlert(title: "提示", message: "请输入用户名和密码")
            return
        }
        
        SVProgressHUD.show()
        apiService.Login(username: username, auth: password) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success:
                self.authService.login(username: username, password: password) { res in
                    self.navigateToHome()
                }
            case .failure:
                self.showAlert(title: "错误", message: "登录失败")
                break
            }
        }
    }
    
    @objc private func biometricsTapped() {
        authService.biometricLogin { [weak self] result in
            guard let self = self else { return }
            if result {
                self.navigateToHome()
            } else {
                self.showAlert(title: "提示", message: "生物识别验证失败")
            }
        }
    }
    
    // 跳转主页（TabBar）
    private func navigateToHome() {
        self.dismiss(animated: true)
    }
    
    // 通用弹窗
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - 简化 UI 组件扩展
extension UITextField {
    convenience init(placeholder: String, isSecure: Bool) {
        self.init()
        self.placeholder = NSLocalizedString(placeholder, comment: "")
        self.borderStyle = .roundedRect
        self.isSecureTextEntry = isSecure
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
}

extension UIButton {
    convenience init(title: String, bgColor: UIColor = .clear, font: UIFont = .systemFont(ofSize: 16, weight: .medium)) {
        self.init(type: .system)
        self.setTitle(NSLocalizedString(title, comment: ""), for: .normal)
        self.backgroundColor = bgColor
        self.setTitleColor(bgColor == .clear ? .systemBlue : .white, for: .normal)
        self.layer.cornerRadius = 8
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.titleLabel?.font = font
    }
}
