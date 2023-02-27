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
        profilePropertiesView.viewController = self
        profilePropertiesView.configureUI()
        addTargets()
        presenter?.getUserModel()
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
    private func addTargets() {
        profilePropertiesView.addLocationButtonTarget(self, action: #selector(tappedLocationButton))
        profilePropertiesView.addAvatarButtonTarget(self, action: #selector(didTapAvatarButton))
        profilePropertiesView.addSaveButtonTarget(self, action: #selector(tappedSaveButton))
    }
}

extension ProfilePropertiesViewController: ProfilePropertiesViewInput {
    
    func addInterest(_ interest: String) {
        presenter?.addInterestPreference(interest)
    }
    
    func removeInterest(_ interest: String) {
        presenter?.removeInterest(interest)
    }
    
    func updateInterests(interests: [Interests]) {
        profilePropertiesView.addInterestsMenuItems(interests: interests)
    }
    
    func updateAlcohol(alcohol: [Alcohol]) {
        profilePropertiesView.addAlcoholMenuItems(alcohol: alcohol)
    }
    
    func setCityName(cityName: String) {
        profilePropertiesView.setLocation(townName: cityName)
    }
    
    func showAlertController() {
        self.present(profilePropertiesView.presentAlertController(), animated: true)
    }
    
    func addAlcohol(_ alcohol: String) {
        presenter?.addAlcoholPreference(alcohol)
    }
    
    func removeAlcohol(_ alcohol: String) {
        presenter?.removeAlcohol(alcohol)
    }
    
    func setUserProperties(user: User) {
        profilePropertiesView.setPropterties(userModel: user)
        profilePropertiesView.addAlcoholMenuItems(alcohol: user.alcohols)
        profilePropertiesView.addInterestsMenuItems(interests: user.interests)
    }
    
    func setAvatarImage(avatarData: Data) {
        DispatchQueue.main.async {
            self.profilePropertiesView.setAvatarImage(imageData: avatarData)
        }
    }
    
    func changePhoto(image: UIImage?) {
        presenter?.changePhoto(image: image)
    }
    
    func changeName(name: String?) {
        presenter?.changeName(name: name)
    }
    
    func changeLocation(location: String?) {
        presenter?.changeLocation(location: location)
    }
    
    func changeBirthdaDate(date: Date?) {
        presenter?.changeBirthdaDate(date: date)
    }
    
    func changeGender(gender: Int?) {
        presenter?.changeGender(gender: gender)
    }
    
    func changeSmoking(smoking: Int?) {
        presenter?.changeSmoking(smoking: smoking)
    }
    
    func changeAlcohol(alcohol: String?) {
        presenter?.changeAlcohol(alcohol: alcohol)
    }
    
    func changeInterests(interests: String?) {
        presenter?.changeInterests(interests: interests)
    }
    
    func changeDescribe(describe: String?) {
        presenter?.changeDescribe(describe: describe)
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
    
    @objc func tappedSaveButton(sender: UIButton) {
        profilePropertiesView.collectSettingsUser()
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
