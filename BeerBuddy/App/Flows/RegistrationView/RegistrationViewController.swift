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
        guard let view = self.view as? RegistrationView
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        registrationView.makeAvatarCircular()
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
        registrationView.addAvatarButtonTarget(self, action: #selector(didTapAddAvatarButton))
    }
    
    // MARK: - Actions
    
    @objc func didTapRegistrationButton(sender: UIButton) {
        guard let avatar = registrationView.avatarImageView.image else { return }
        presenter?.didTapRegistrationButton(name: registrationView.nameText,
                                            login: registrationView.loginText,
                                            password: registrationView.passwordText,
                                            repeatPassword: registrationView.repeatPasswordText,
                                            avatar: avatar)
    }
    
    @objc func didTapAddAvatarButton(sender: UIButton) {
        presentPhotoActionSheet()
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

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else { return }
        registrationView.avatarImageView.image = image
    }
    
    func presentPhotoActionSheet() {
        let ac = UIAlertController(title: "Profile picture",
                                   message: "How would you like to select a picture?",
                                   preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
            self?.pickImage(from: .camera)
        })
        ac.addAction(UIAlertAction(title: "Choose Photo", style: .default) { [weak self] _ in
            self?.pickImage(from: .photoLibrary)
        })
        present(ac, animated: true)
    }
    
    func pickImage(from source: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.sourceType = source
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}
