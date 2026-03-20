// Sources/Features/Auth/LoginViewController.swift
import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    // UI 组件
    private let usernameTF = UITextField(placeholder: "用户名", isSecure: false)
    private let passwordTF = UITextField(placeholder: "密码", isSecure: true)
    private let loginBtn = UIButton(title: "登录", bgColor: .systemBlue)
    private let biometricsBtn = UIButton(title: "生物识别登录", font: .systemFont(ofSize: 14))
    
    // 依赖注入（协议解耦）
    private let authService: AuthServiceProtocol
    private let apiService: GitHubAPIServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService(),
         apiService: GitHubAPIServiceProtocol = GitHubAPIService()) {
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
    
    // MARK: - UI 配置
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("登录", comment: "")
        
        // 布局（SnapKit）
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
    
    // 生物识别可用性检查
    private func setupBiometrics() {
        biometricsBtn.isHidden = !authService.isBiometricsAvailable()
    }
    
    // MARK: - 事件处理
    @objc private func loginTapped() {
        guard let username = usernameTF.text, !username.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
            showAlert(title: "提示", message: "请输入用户名和密码")
            return
        }
        
        // 保存凭证（实际需验证 GitHub 账号，此处简化）
        do {
            try authService.saveCredentials(username: username, password: password)
            navigateToHome() // 跳转主页
        } catch {
            showAlert(title: "错误", message: error.localizedDescription)
        }
    }
    
    @objc private func biometricsTapped() {
        authService.authenticateWithBiometrics { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(true):
                // 生物识别成功，跳转主页
                self.navigateToHome()
            case .success(false):
                self.showAlert(title: "提示", message: "生物识别验证失败")
            case .failure(let error):
                self.showAlert(title: "错误", message: error.localizedDescription)
            }
        }
    }
    
    // 跳转主页（TabBar）
    private func navigateToHome() {
        let tabBar = MainTabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
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
