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
    
    private(set) lazy var backgroundImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: AppData.imageName.waveBackground)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AppData.imageName.missingPhoto)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private(set) lazy var addAvatarButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADD", for: .normal)
        button.setTitleColor(
            AppStyles.color.black,
            for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI public method
    
    public func configureUI() {
        setupBackground()
        addScrollView()
        addNameTextField()
        addAvatarImage()
        createAddButton()
        addLoginTextField()
        addPasswordTextField()
        addRepeatPasswordTextField()
        addRegistrationButton()
    }
    
    // MARK: - Private methods
    
    private func setupBackground() {
        self.addSubview(backgroundImage)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
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

    private func createAddButton() {
        avatarImageView.addSubview(addAvatarButton)

        NSLayoutConstraint.activate([
            addAvatarButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            addAvatarButton.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            addAvatarButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            addAvatarButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
    }

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
