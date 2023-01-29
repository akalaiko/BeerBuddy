//
//  LoginView.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 14.01.2023.
//

import UIKit

final class LoginView: UIView {
    
    // MARK: - Private properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.frame = self.bounds
        scrollView.contentSize = contentSize
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
        view.frame.size = contentSize
        return view
    }()
    
    private var contentSize: CGSize {
        CGSize(width: frame.size.width, height: frame.size.height + 10)
    }
    
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
    
    private(set) lazy var loginTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Login")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        return textField
    }()
    
    private(set) lazy var passwordTextField: CustomTextField = {
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
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    func configureUI() {
        addScrollView()
        setupBackground()
        addLoginTextField()
        addNameAppLabel()
        addAvatarImage()
        addPasswordTextField()
        addLoginButton()
        addRegistrationButton()
    }
    
    private func addScrollView() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupBackground() {
        let background = UIImage(named: AppData.imageName.waveBackground)
        
        var imageView = UIImageView()
        imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = contentView.center
        self.addSubview(imageView)
        self.sendSubviewToBack(imageView)
    }

    private func addLoginTextField() {
        contentView.addSubview(loginTextField)
        
        NSLayoutConstraint.activate([
            loginTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: AppStyles.size.horizontalMargin.big),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                     constant: -AppStyles.size.horizontalMargin.big),
            loginTextField.heightAnchor.constraint(equalToConstant: AppStyles.size.height.textfield)
        ])
    }

    private func addNameAppLabel() {
        contentView.addSubview(nameAppLabel)

        NSLayoutConstraint.activate([
            nameAppLabel.bottomAnchor.constraint(equalTo: loginTextField.topAnchor,
                                                 constant: -AppStyles.size.verticalMargin.middle),
            nameAppLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    private func addAvatarImage() {
        guard let width = avatarImageView.image?.size.width,
                let height = avatarImageView.image?.size.height else { return }

        let multiplierHeight = height / width

        contentView.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: nameAppLabel.topAnchor,
                                                    constant: -AppStyles.size.verticalMargin.small),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.42),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: multiplierHeight)
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
            registrationButton.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor)
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
        guard let info = notification.userInfo as? NSDictionary,
              let keyboardSize = info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue
        else { return }
        let kbSize = keyboardSize.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        scrollView.isScrollEnabled = true
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        UIView.animate(withDuration: 1) {
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardShown" })?
                .priority = .required
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardHide" })?
                .priority = .defaultHigh
            self.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.isScrollEnabled = false
        scrollView.contentInset = contentInsets
        UIView.animate(withDuration: 1) {
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardShown" })?
                .priority = .defaultHigh
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardHide" })?
                .priority = .required
            self.layoutIfNeeded()
        }
    }
    
    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }
}
