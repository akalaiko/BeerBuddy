//
//  RegistrationView.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 17.01.2023.
//

import Foundation
import UIKit

class RegistrationView: UIView {
    
    // MARK: - Private properties
    
    /// Initilazing view's components.
    
    private lazy var backgroundImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: AppData.imageName.waveBackground)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
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
        imageView.image = UIImage(named: AppData.imageName.missingPhoto)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var addAvatarLabel: UILabel = {
        let label = UILabel()
        label.text = "ADD"
        label.textColor = AppStyles.color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var nameTextField: CustomTextField = {
        let textField = CustomTextField(
            restriction: .lettersOnly,
            minLength: 2,
            placeholder: "Name")
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var loginTextField: CustomTextField = {
        let textField = CustomTextField(
            minLength: 3,
            placeholder: "Login")
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(
            minLength: 8,
            isSecure: true,
            placeholder: "Password")
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var repeatPasswordTextField: CustomTextField = {
        let textField = CustomTextField(
            minLength: 8,
            isSecure: true,
            placeholder: "Repeat Password")
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var registrationButton: CustomButton = {
        let button = CustomButton(title: "REGISTER")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var nameText: String {
        nameTextField.text ?? ""
    }
    
    var loginText: String {
        loginTextField.text ?? ""
    }
    
    var passwordText: String {
        passwordTextField.text ?? ""
    }
    
    var repeatPasswordText: String {
        repeatPasswordTextField.text ?? ""
    }
    
    // MARK: - Initialization
    
    /// Creates  view with zero frame.
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    
    /// Setting up visual components.
    func configureUI() {
        setupBackground()
        addScrollView()
        addNameTextField()
        addAvatarImage()
        createAddLabel()
        addLoginTextField()
        addPasswordTextField()
        addRepeatPasswordTextField()
        addRegistrationButton()
    }
    
    // MARK: - Private methods
    
    /// .Setting up background.
    private func setupBackground() {
        self.addSubview(backgroundImage)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    /// Setting up scroll view.
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
    
    /// Setting up name textfield.
    private func addNameTextField() {
        contentView.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: AppStyles.size.horizontalMargin.big),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -AppStyles.size.horizontalMargin.big),
            nameTextField.heightAnchor.constraint(equalToConstant: AppStyles.size.height.textfield)
        ])
    }
    
    /// Setting up user's avatar image.
    ///
    /// By tapping on this image you can add a user avatar.
    private func addAvatarImage() {
        contentView.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: nameTextField.topAnchor,
                                                    constant: -AppStyles.size.verticalMargin.big),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: nameTextField.widthAnchor, multiplier: 0.55),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])
    }
    
    /// Setting up "add" label.
    ///
    ///  By tapping on this label you can add a user avatar.
    private func createAddLabel() {
        avatarImageView.addSubview(addAvatarLabel)
        
        NSLayoutConstraint.activate([
            addAvatarLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            addAvatarLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor)
        ])
    }
    
    /// Setting up login textfield.
    private func addLoginTextField() {
        contentView.addSubview(loginTextField)
        
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,
                                                constant: AppStyles.size.verticalMargin.small),
            loginTextField.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            loginTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            loginTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor)
        ])
    }
    
    /// Setting up password textfield.
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
    
    /// Setting up repeat password textfield.
    private func addRepeatPasswordTextField() {
        contentView.addSubview(repeatPasswordTextField)
        
        NSLayoutConstraint.activate([
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                                         constant: AppStyles.size.verticalMargin.small),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            repeatPasswordTextField.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor)
        ])
    }
    
    /// Setting up registration button.
    private func addRegistrationButton() {
        contentView.addSubview(registrationButton)
        
        NSLayoutConstraint.activate([
            registrationButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor,
                                                    constant: AppStyles.size.verticalMargin.big),
            registrationButton.leadingAnchor.constraint(equalTo: repeatPasswordTextField.leadingAnchor),
            registrationButton.trailingAnchor.constraint(equalTo: repeatPasswordTextField.trailingAnchor),
            registrationButton.heightAnchor.constraint(equalTo: repeatPasswordTextField.heightAnchor),
            registrationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Public methods
    
    func subscribeObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addRegistrationButtonTarget(_ target: Any, action: Selector) {
        registrationButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    /// A method that hides the keyboard when tapped.
    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }
    
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
}
