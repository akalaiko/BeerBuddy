//
//  RegistrationViewController.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 17.01.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var registrationView: RegistrationView {
        guard
            let view = self.view as? RegistrationView
        else {
            let correctView = RegistrationView()
            self.view = correctView
            return correctView
        }
        return view
    }
    
    /// Controller's presenter.
    private var presenter: RegistrationViewOutput?
    
    // MARK: - Initialization
    
    /// Created controller screen "Registration".
    /// - Parameter presenter: Controller's presenter.
    init(presenter: RegistrationViewOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = registrationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationView.configureUI()
        setupActionForButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registrationView.subscribeObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        registrationView.unsubscribeObserver()
    }
    
    // MARK: - Private methods
    
    private func setupActionForButton() {
        registrationView.addRegistrationButtonTarget(self, action: #selector(didTapRegistrationButton))
    }
    
    // MARK: - Actions
    
    @objc func didTapRegistrationButton(sender: UIButton) {
        presenter?.didTapRegistrationButton(name: registrationView.nameText,
                                            login: registrationView.loginText,
                                            password: registrationView.passwordText,
                                            repeatPassword: registrationView.repeatPasswordText)
    }
}

// MARK: - Extensions

extension RegistrationViewController: RegistrationViewInput {
    
    func alertLoginError(message: String) {
        let alert = UIAlertController(title: "Ooops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
}
