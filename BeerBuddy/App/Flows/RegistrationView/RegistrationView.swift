//
//  RegistrationView.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 17.01.2023.
//

import UIKit
import Foundation

class RegistrationView: UIView {
    
    // MARK: - Private properties
    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.frame = self.bounds
        scrollView.contentSize = contentSize
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(hideKeyboard)))
        
        return scrollView
    }()
    
    private(set) lazy var contentView: UIView = {
        let view = UIView()
        view.frame.size = contentSize
        
        return view
    }()
    
    private var contentSize: CGSize {
        CGSize(
            width: frame.size.width,
            height: frame.size.height + 10)
    }
    
    private(set) lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: AppData.imageName.missingPhoto)
        
        return imageView
    }()
    
    private(set) lazy var addAvatarButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADD", for: .normal)
        button.setTitleColor(
            AppStyles.color.black,
            for: .normal)
        
        return button
    }()
    
    private(set) lazy var nameTextField: CustomTextField = {
        let textField = CustomTextField(
            restriction: .lettersOnly,
            minLength: 2,
            placeholder: "Name")
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private(set) lazy var loginTextField: CustomTextField = {
        let textField = CustomTextField(
            minLength: 3,
            placeholder: "Login")
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private(set) lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(
            minLength: 8,
            placeholder: "Password")
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private(set) lazy var repeatPasswordTextField: CustomTextField = {
        let textField = CustomTextField(
            minLength: 8,
            placeholder: "Repeat Password")
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private(set) lazy var registrationButton: CustomButton = {
        let button = CustomButton(title: "REGISTER")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //MARK: - Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI public method
    public func configureUI() {
        addScrollView()
        setupBackground()
        addNameTextField()
        addAvatarImage()
        createAddButton()
        addLoginTextField()
        addPasswordTextField()
        addRepeatPasswordTextField()
        addRegistrationButton()
    }
    
    // MARK: - Private methods
    private func addScrollView() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupBackground() {
        let background = UIImage(named: AppData.imageName.waveBackground)
        var imageView = UIImageView()
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = contentView.center
        self.scrollView.addSubview(imageView)
        self.scrollView.sendSubviewToBack(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func addAvatarImage() {
        guard
            let width = avatarImageView.image?.size.width,
            let height = avatarImageView.image?.size.width
        else { return }
        
        let multiplier = (height / width) / 2
        
        contentView.addSubview(avatarImageView)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -AppStyles.size.verticalMargin.middle),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: multiplier),
            avatarImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: multiplier)
        ])
    }
    
    private func createAddButton() {
        contentView.addSubview(addAvatarButton)
        
        addAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addAvatarButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            addAvatarButton.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            addAvatarButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            addAvatarButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
    }
    
    private func addNameTextField() {
        contentView.addSubview(nameTextField)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -AppStyles.size.horizontalMargin.big),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppStyles.size.horizontalMargin.big),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppStyles.size.horizontalMargin.big),
            nameTextField.heightAnchor.constraint(equalToConstant: AppStyles.size.height.textfield)
        ])
    }
    
    private func addLoginTextField() {
        contentView.addSubview(loginTextField)
        
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: AppStyles.size.verticalMargin.small),
            loginTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            loginTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor)
        ])
    }
    
    private func addPasswordTextField() {
        contentView.addSubview(passwordTextField)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: AppStyles.size.verticalMargin.small),
            passwordTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor)
        ])
    }
    
    private func addRepeatPasswordTextField() {
        contentView.addSubview(repeatPasswordTextField)
        
        repeatPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: AppStyles.size.verticalMargin.small),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            repeatPasswordTextField.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor)
        ])
    }
    
    private func addRegistrationButton() {
        contentView.addSubview(registrationButton)
        
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            registrationButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: AppStyles.size.verticalMargin.small),
            registrationButton.leadingAnchor.constraint(equalTo: repeatPasswordTextField.leadingAnchor),
            registrationButton.trailingAnchor.constraint(equalTo: repeatPasswordTextField.trailingAnchor),
            registrationButton.heightAnchor.constraint(equalTo: repeatPasswordTextField.heightAnchor)
        ])
    }
    
    // MARK: - Public methods
    public func subscribeObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWasShown),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillBeHidden),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    public func unsubscribeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    public func addRegistrationButtonTarget(_ target: Any, action: Selector) {
        registrationButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

// MARK: - Extensions
extension RegistrationView {
    // MARK: - Obj-C keyboard methods
    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }
}

extension RegistrationView {
    // MARK: - Obj-C keyboard observer methods
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
}

