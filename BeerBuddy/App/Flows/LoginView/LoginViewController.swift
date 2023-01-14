//
//  LoginViewController.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 14.01.2023.
//

import UIKit

protocol LoginViewInput: AnyObject {
    
}

final class LoginViewController: UIViewController {
    
    // MARK: - Private properties
    private var loginView: LoginView {
        guard let view = self.view as? LoginView else {
            let correctView = LoginView(frame: self.view.frame)
            self.view = correctView
            return correctView
        }
        return view
    }
    
    // MARK: - Properties
    var presenter: LoginViewOutput?
    
    // MARK: - Init
    init(presenter: LoginViewOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActionsForButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginView.subscribeObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loginView.unsubscribeObserver()
    }
    
    // MARK: - Private methods
    private func setupActionsForButton() {
        loginView.loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        loginView.registrationButton.addTarget(self, action: #selector(tappedRegistration), for: .touchUpInside)
    }
}

// MARK: - @objc func
extension LoginViewController {
    @objc func tappedLoginButton(sender: UIButton) {
        presenter?.tappedLoginButton()
    }
    
    @objc func tappedRegistration() {
        presenter?.tappedRegistrationButton()
    }
}

// MARK: - Release LoginViewInput
extension LoginViewController: LoginViewInput {
    
}
