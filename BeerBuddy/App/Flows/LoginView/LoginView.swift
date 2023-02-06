//
//  LoginView.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 14.01.2023.
//

import UIKit

final class LoginView: UIView {
    
    // MARK: - Private properties
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: AppData.imageName.waveBackground)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = false
        scrollView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(hideKeyboard)))
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: AppData.imageName.bearLogin)
        return imageView
    }()
    
    private lazy var nameAppLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BEER BUDDY"
        label.font = AppStyles.font.logo
        label.textColor = AppStyles.color.brown
        return label
    }()
    
    private lazy var loginTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Login")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(isSecure: true, placeholder: "Password")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var loginButton: CustomButton = {
        let button = CustomButton(title: "LOG IN")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = "REGISTRATION"
        let titleString = NSMutableAttributedString(string: title)
        titleString.addAttribute(.underlineStyle,
                                 value: NSUnderlineStyle.single.rawValue,
                                 range: NSRange(location: 0, length: title.count))
        button.setAttributedTitle(titleString, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        return button
    }()
    
    var loginText: String {
        loginTextField.text ?? ""
    }
    
    var passwordText: String {
        passwordTextField.text ?? ""
    }
    
    // MARK: - Init

    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    func configureUI() {
        setupBackground()
        addScrollView()
        addAvatarImage()
        addNameAppLabel()
        addLoginTextField()
        addPasswordTextField()
        addLoginButton()
        addRegistrationButton()
    }
    
    private func setupBackground() {
        self.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addScrollView() {
        self.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(greaterThanOrEqualTo: scrollView.topAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor)
        ])

        scrollView.contentSize = contentView.frame.size
    }
    
    private func addAvatarImage() {
        guard let width = avatarImageView.image?.size.width,
                let height = avatarImageView.image?.size.height else { return }

        let multiplierHeight = height / width

        contentView.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.42),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: multiplierHeight)
        ])
    }
    
    private func addNameAppLabel() {
        contentView.addSubview(nameAppLabel)

        NSLayoutConstraint.activate([
            nameAppLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor,
                                              constant: AppStyles.size.verticalMargin.small),
            nameAppLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor)
        ])
    }
    
    private func addLoginTextField() {
        contentView.addSubview(loginTextField)
        
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: nameAppLabel.bottomAnchor,
                                                constant: AppStyles.size.verticalMargin.small),
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: AppStyles.size.horizontalMargin.big),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                     constant: -AppStyles.size.horizontalMargin.big),
            loginTextField.heightAnchor.constraint(equalToConstant: AppStyles.size.height.textfield),
            loginTextField.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
    }

    private func addPasswordTextField() {
        contentView.addSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor,
                                                   constant: AppStyles.size.verticalMargin.small),
            passwordTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor)
        ])
    }
    
    private func addLoginButton() {
        contentView.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                             constant: AppStyles.size.verticalMargin.small),
            loginButton.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalTo: loginTextField.heightAnchor)
        ])
    }
    
    private func addRegistrationButton() {
        contentView.addSubview(registrationButton)
        
        NSLayoutConstraint.activate([
            registrationButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor,
                                                    constant: AppStyles.size.verticalMargin.small),
            registrationButton.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            registrationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Methods
    
    func subscribeObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWasShown),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    func unsubscribeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    func addLoginButtonTarget(_ target: Any, action: Selector) {
        loginButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func addRegistrationButtonTarget(_ target: Any, action: Selector) {
        registrationButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

// MARK: - Observer Keyboard

extension LoginView {
    @objc func keyboardWasShown(notification: Notification) {
        guard let keyboardValue = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)

        let contentInsets = UIEdgeInsets(top: -contentView.frame.minY + safeAreaInsets.top,
                                         left: 0,
                                         bottom: keyboardViewEndFrame.height,
                                         right: 0)

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets

        scrollView.setContentOffset(.init(x: contentView.frame.minX,
                                          y: contentView.frame.maxY - keyboardViewEndFrame.minY),
                                    animated: true)
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets: UIEdgeInsets = .zero

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }
}
