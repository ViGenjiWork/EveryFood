//
//  AuthView.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 18.06.2022.
//

import UIKit

protocol IAuthView: UIView {
    func didLoad()
    
    var didTapLoginButtonHandler: ((String, String)->Void)? { get set }
}

final class AuthView: UIView {
    
    private enum Metrics {
        static let logoViewCornerRadius: CGFloat = 30
        static let underlineCorderRaius: CGFloat = 2
        
        static let logoImageViewSize: CGFloat = 150
        static let logoViewMultiplier: CGFloat = 0.6
        
        static let loginButtonBottomOffset: CGFloat = 10
        static let loginButtonHorizontalOffset: CGFloat = 30
        static let loginButtonHeight: CGFloat = 70
        
        static let underlineMultiplier: CGFloat = 0.5
        static let underlineHeight: CGFloat = 3
        
        static let emailTextFieldTopOffset: CGFloat = 30
        static let passwordTextFieldTopOffset: CGFloat = 45
        static let textFieldHorizontalOffset: CGFloat = 45
        static let textFieldHeight: CGFloat = 60
    }
    
    private enum Texts {
        static let logoImageName: String = "logo"
        static let authButtonTitie: String = "Login"
        static let registerButtonTitle: String = "Sign-up"
        
        static let emailTextFieldTitle: String = "Email addess"
        static let emailTextFieldPlaceholder: String = "Enter your email here"
        static let passwordTextFieldTitle: String = "Password"
        static let passwordTextFieldPlaceholder: String = "Enter your password here"
        
        static let loginButtonTitle: String = "Login"
    }
    
    var didTapLoginButtonHandler: ((String, String) -> Void)?
    
    private lazy var logoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Metrics.logoViewCornerRadius
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Texts.logoImageName)
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var authBtn: UIButton = {
        let button = UIButton()
        button.setTitle(Texts.authButtonTitie, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(setAuthViewActive), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerBtn: UIButton = {
        let button = UIButton()
        button.setTitle(Texts.registerButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(setRegisterViewActive), for: .touchUpInside)
        return button
    }()
    
    private lazy var underline: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystemOrange
        view.layer.cornerRadius = Metrics.underlineCorderRaius
        return view
    }()
    
    private lazy var authView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystemMainBG
        return view
    }()
    
    private lazy var emailTextField = TextFieldBuilder()
        .withTitle(title: Texts.emailTextFieldTitle)
        .setKeyboardType(type: .emailAddress)
        .withPlaceholder(placeholder: Texts.emailTextFieldPlaceholder)
        .build()
    
    private lazy var passwordTextField = TextFieldBuilder()
        .withTitle(title: Texts.passwordTextFieldTitle)
        .withPlaceholder(placeholder: Texts.passwordTextFieldPlaceholder)
        .build()
    
    private lazy var loginButton = Button(with: .init(title: Texts.loginButtonTitle, tapHandler: {
        var email: String?
        var password: String?
        for view in self.emailTextField.subviews {
            if let emailValue = view as? UnderlinedTextField {
                email = emailValue.text ?? ""
            }
        }
        
        for view in self.passwordTextField.subviews {
            if let passwordValue = view as? UnderlinedTextField {
                password = passwordValue.text ?? ""
            }
        }
        guard let email = email,
              let password = password else {
                  return
              }
        self.loginButtonAction(email: email, password: password)
    }))
    
    @objc func loginButtonAction(email: String, password: String) {
        self.didTapLoginButtonHandler?(email, password)
    }
}

extension AuthView: IAuthView {
    func didLoad() {
        self.backgroundColor = .designSystemMainBG
        
        self.setupLayout()
        self.setAuthViewActive()
    }
}

private extension AuthView {
    func setupLayout() {
        self.addSubview(self.logoView)
        self.logoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.logoView.topAnchor.constraint(equalTo: self.topAnchor),
            self.logoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.logoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.logoView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                  constant: -(UIScreen.main.bounds.height * Metrics.logoViewMultiplier))
        ])
        
        self.logoView.addSubview(self.logoImageView)
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.logoImageView.heightAnchor.constraint(equalToConstant: Metrics.logoImageViewSize),
            self.logoImageView.widthAnchor.constraint(equalToConstant: Metrics.logoImageViewSize),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.logoView.centerXAnchor),
            self.logoImageView.centerYAnchor.constraint(equalTo: self.logoView.centerYAnchor)
        ])
        
        self.stackView.addArrangedSubview(self.authBtn)
        self.registerBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.stackView.addArrangedSubview(self.registerBtn)
        self.authBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.logoView.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.stackView.bottomAnchor.constraint(equalTo: self.logoView.bottomAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.addSubview(self.loginButton)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.loginButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -Metrics.loginButtonBottomOffset),
            self.loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrics.loginButtonHorizontalOffset),
            self.loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metrics.loginButtonHorizontalOffset),
            self.loginButton.heightAnchor.constraint(equalToConstant: Metrics.loginButtonHeight)
        ])
    }
    
    @objc func setRegisterViewActive() {
        self.registerBtn.addSubview(self.underline)
        self.underline.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.underline.bottomAnchor.constraint(equalTo: self.registerBtn.bottomAnchor),
            self.underline.widthAnchor.constraint(equalTo: self.registerBtn.widthAnchor, multiplier: Metrics.underlineMultiplier),
            self.underline.heightAnchor.constraint(equalToConstant: Metrics.underlineHeight),
            self.underline.centerXAnchor.constraint(equalTo: self.registerBtn.centerXAnchor)
        ])
    }
    
    @objc func setAuthViewActive() {
        self.authBtn.addSubview(self.underline)
        self.underline.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.underline.bottomAnchor.constraint(equalTo: self.authBtn.bottomAnchor),
            self.underline.widthAnchor.constraint(equalTo: self.authBtn.widthAnchor, multiplier: Metrics.underlineMultiplier),
            self.underline.heightAnchor.constraint(equalToConstant: Metrics.underlineHeight),
            self.underline.centerXAnchor.constraint(equalTo: self.authBtn.centerXAnchor)
        ])
        
        self.setupAuthView()
    }
    
    
    func setupAuthView() {
        self.addSubview(self.emailTextField)
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.emailTextField.topAnchor.constraint(equalTo: self.logoView.bottomAnchor, constant: Metrics.emailTextFieldTopOffset),
            self.emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrics.textFieldHorizontalOffset),
            self.emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metrics.textFieldHorizontalOffset),
            self.emailTextField.heightAnchor.constraint(equalToConstant: Metrics.textFieldHeight)
        ])
        
        self.addSubview(self.passwordTextField)
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: Metrics.passwordTextFieldTopOffset),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrics.textFieldHorizontalOffset),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metrics.textFieldHorizontalOffset),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: Metrics.textFieldHeight)
        ])
    }
}
