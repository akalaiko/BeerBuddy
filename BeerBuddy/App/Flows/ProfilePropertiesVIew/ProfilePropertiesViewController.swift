//
//  ProfilePropertiesViewController.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 11.02.2023.
//

import UIKit

class ProfilePropertiesViewController: UIViewController {
    
    private var profilePropertiesView: ProfilePropertiesView {
        guard let view = self.view as? ProfilePropertiesView else {
            let correctView = ProfilePropertiesView()
            return correctView
        }
        
        return view
    }
    
    var presenter: ProfilePropertiesViewOutput?
    
    // MARK: - Init
    
    init(presenter: ProfilePropertiesViewOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = profilePropertiesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePropertiesView.configureUI()
        profilePropertiesView.addLocationButtonTarget(self, action: #selector(tappedLocationButton))
        profilePropertiesView.addAvatarButtonTarget(self, action: #selector(didTapAvatarButton))
        setUserProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profilePropertiesView.subscribeObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profilePropertiesView.unsubscribeObserver()
        presenter?.stopLocationUpdate()
    }
    
    private func setUserProperties() {
        guard let userModel = presenter?.getUserModel() else { return }
        profilePropertiesView.setPropterties(userModel: userModel)
    }
}

extension ProfilePropertiesViewController: ProfilePropertiesViewInput {
    func setCityName(cityName: String) {
        self.profilePropertiesView.setLocation(townName: cityName)
    }
    
    func showAlertController() {
        self.present(profilePropertiesView.presentAlertController(), animated: true)
    }
}

// MARK: - Objc methods

extension ProfilePropertiesViewController {
    @objc func tappedLocationButton(sender: UIButton) {
        presenter?.getCityName()
    }
    
    @objc func didTapAvatarButton(sender: UIButton) {
        presentPhotoActionSheet()
    }
}

extension ProfilePropertiesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else { return }
        profilePropertiesView.setAvatarImage(image: image)
    }
    
    func presentPhotoActionSheet() {
        let alertContoller = UIAlertController(title: "Profile picture",
                                   message: "How would you like to select a picture?",
                                   preferredStyle: .actionSheet)
        alertContoller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertContoller.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
            self?.pickImage(from: .camera)
        })
        alertContoller.addAction(UIAlertAction(title: "Choose Photo", style: .default) { [weak self] _ in
            self?.pickImage(from: .photoLibrary)
        })
        present(alertContoller, animated: true)
    }
    
    func pickImage(from source: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = source
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
}
