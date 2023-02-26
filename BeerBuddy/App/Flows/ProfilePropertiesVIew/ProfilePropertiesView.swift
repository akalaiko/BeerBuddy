//
//  ProfilePropertiesView.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 11.02.2023.
//

import UIKit

final class ProfilePropertiesView: UIView {
    
    // MARK: - Properties
    
    private var showTextField = true
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .clear
        scrollView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(hideKeyboard)))
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        let imageName = "avatar"
        imageView.image = UIImage(named: imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var avatarButton: UIButton = {
        let button = UIButton()
        button.setTitle("EDIT", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        //        label.text = "USERNAME"
        label.font = AppStyles.font.username
        label.textColor = AppStyles.color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: AppData.imageName.pencil), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapNameButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: nameLabel.text ?? "")
        textField.isHidden = true
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday:"
        label.font = AppStyles.font.button
        label.textColor = AppStyles.color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var birthdayDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.calendar = .current
        datePicker.datePickerMode = .date
        datePicker.maximumDate = .distantFuture
        datePicker.minimumDate = .distantPast
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location:"
        label.font = AppStyles.font.button
        label.textColor = AppStyles.color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(AppStyles.color.swamp, for: .normal)
        button.setAttributedTitle(attributedString(title: "Set current location"),
                                  for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var mapIconButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: AppData.imageName.mapIcon), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender:"
        label.font = AppStyles.font.button
        label.textColor = AppStyles.color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genderSegmentedControl: CustomSegmentedControl = {
        let segmentControl = CustomSegmentedControl(items: ["Male", "Female", "Other"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    private lazy var smokingLabel: UILabel = {
        let label = UILabel()
        label.text = "Are you ok with smoking?"
        label.font = AppStyles.font.button
        label.textColor = AppStyles.color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var smokingSegmentedControl: CustomSegmentedControl = {
        let segmentControl = CustomSegmentedControl(items: ["I smoke", "Im OK", "Nope"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    private lazy var alcoholLabel: UILabel = {
        let label = UILabel()
        label.text = "Alcohol preference:"
        label.font = AppStyles.font.button
        label.textColor = AppStyles.color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var alcoholButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: AppData.imageName.plusCircle), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var alcoholTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = textView.frame.size.height / 2
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.text = "Choose what you like🥰"
        textView.textColor = UIColor.gray
        return textView
    }()
    
    private lazy var interestsLabel: UILabel = {
        let label = UILabel()
        label.text = "Interests:"
        label.font = AppStyles.font.button
        label.textColor = AppStyles.color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var interestsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: AppData.imageName.plusCircle), for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var interestTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = textView.frame.size.height / 2
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Choose what you like🥰"
        textView.textColor = UIColor.gray
        return textView
    }()
    
    private lazy var describeLabel: UILabel = {
        let label = UILabel()
        label.text = "Describe yourself or \nwhat are you looking for?"
        label.numberOfLines = 2
        label.textColor = AppStyles.color.black
        label.font = AppStyles.font.button
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var describeTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = textView.frame.size.height / 2
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var saveButton: CustomButton = {
        let button = CustomButton(title: "SAVE")
        button.backgroundColor = AppStyles.color.swamp
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var alertController: UIAlertController = {
        let alertController = UIAlertController(title: "Ooops",
                                                message: "Please enable location permissions in settings.",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        return alertController
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.settingCornerRadius()
        }
    }
    
    private func settingCornerRadius() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
        alcoholTextView.layer.cornerRadius = AppStyles.cornerRadius.textView
        interestTextView.layer.cornerRadius = AppStyles.cornerRadius.textView
        describeTextView.layer.cornerRadius = AppStyles.cornerRadius.textView
        nameTextField.layer.cornerRadius = AppStyles.cornerRadius.textView
    }
    
    private func attributedString(title: String) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: AppStyles.font.button,
            NSAttributedString.Key.foregroundColor: AppStyles.color.swamp,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        return attributedString
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
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.42),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: multiplierHeight)
        ])
    }
    
    private func addAvatarLabel() {
        contentView.addSubview(avatarButton)
        
        NSLayoutConstraint.activate([
            avatarButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor,
                                                 constant: -AppStyles.size.verticalMargin.small),
            avatarButton.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor)
        ])
    }
    
    private func addNameView() {
        contentView.addSubview(nameView)
        
        NSLayoutConstraint.activate([
            nameView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor,
                                          constant: AppStyles.size.verticalMargin.middle),
            nameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: AppStyles.size.horizontalMargin.big),
            nameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -AppStyles.size.horizontalMargin.big),
            nameView.heightAnchor.constraint(equalToConstant: AppStyles.size.height.textfield)
        ])
    }
    
    private func addUsernameLabel() {
        nameView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: nameView.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: nameView.centerXAnchor)
        ])
    }
    
    private func addNameTextField() {
        nameView.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            nameTextField.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: nameLabel.widthAnchor, multiplier: 1.5),
            nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor)
        ])
    }
    
    private func addNameButton() {
        nameView.addSubview(nameButton)
        
        NSLayoutConstraint.activate([
            nameButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            nameButton.trailingAnchor.constraint(equalTo: nameView.trailingAnchor,
                                                 constant: -AppStyles.size.horizontalMargin.small)
        ])
    }
    
    private func addBirthdayLabel() {
        contentView.addSubview(birthdayLabel)
        
        NSLayoutConstraint.activate([
            birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                               constant: AppStyles.size.verticalMargin.big),
            birthdayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: AppStyles.size.horizontalMargin.middle)
        ])
    }
    
    private func addDatePicker() {
        contentView.addSubview(birthdayDatePicker)
        
        NSLayoutConstraint.activate([
            birthdayDatePicker.centerYAnchor.constraint(equalTo: birthdayLabel.centerYAnchor),
            birthdayDatePicker.leadingAnchor.constraint(equalTo: birthdayLabel.trailingAnchor,
                                                        constant: AppStyles.size.horizontalMargin.middle),
            birthdayDatePicker.heightAnchor.constraint(equalTo: birthdayLabel.heightAnchor)
        ])
    }
    
    private func addLocationLabel() {
        contentView.addSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor,
                                               constant: AppStyles.size.verticalMargin.middle),
            locationLabel.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor)
        ])
    }
    
    private func addSetLocationButton() {
        contentView.addSubview(locationButton)
        
        NSLayoutConstraint.activate([
            locationButton.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            locationButton.leadingAnchor.constraint(equalTo: birthdayDatePicker.leadingAnchor),
            locationButton.heightAnchor.constraint(equalTo: birthdayDatePicker.heightAnchor)
        ])
    }
    
    private func addMapIconButton() {
        contentView.addSubview(mapIconButton)
        
        NSLayoutConstraint.activate([
            mapIconButton.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            mapIconButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -AppStyles.size.horizontalMargin.middle)
        ])
    }
    
    private func addGenderLabel() {
        contentView.addSubview(genderLabel)
        
        NSLayoutConstraint.activate([
            genderLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor,
                                             constant: AppStyles.size.verticalMargin.middle),
            genderLabel.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor)
        ])
    }
    
    private func addGenderSegmenterControl() {
        contentView.addSubview(genderSegmentedControl)
        
        NSLayoutConstraint.activate([
            genderSegmentedControl.topAnchor.constraint(equalTo: genderLabel.bottomAnchor,
                                                        constant: AppStyles.size.verticalMargin.small),
            genderSegmentedControl.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor),
            genderSegmentedControl.trailingAnchor.constraint(equalTo: mapIconButton.trailingAnchor),
            genderSegmentedControl.heightAnchor.constraint(equalTo: birthdayDatePicker.heightAnchor)
        ])
    }
    
    private func addSmokingLabel() {
        contentView.addSubview(smokingLabel)
        
        NSLayoutConstraint.activate([
            smokingLabel.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor,
                                              constant: AppStyles.size.verticalMargin.middle),
            smokingLabel.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor)
        ])
    }
    
    private func addSmokingSegmentedControl() {
        contentView.addSubview(smokingSegmentedControl)
        
        NSLayoutConstraint.activate([
            smokingSegmentedControl.topAnchor.constraint(equalTo: smokingLabel.bottomAnchor,
                                                         constant: AppStyles.size.verticalMargin.small),
            smokingSegmentedControl.leadingAnchor.constraint(equalTo: genderSegmentedControl.leadingAnchor),
            smokingSegmentedControl.trailingAnchor.constraint(equalTo: genderSegmentedControl.trailingAnchor),
            smokingSegmentedControl.heightAnchor.constraint(equalTo: genderSegmentedControl.heightAnchor)
        ])
    }
    
    private func addAlcoholLabel() {
        contentView.addSubview(alcoholLabel)
        
        NSLayoutConstraint.activate([
            alcoholLabel.topAnchor.constraint(equalTo: smokingSegmentedControl.bottomAnchor,
                                              constant: AppStyles.size.verticalMargin.middle),
            alcoholLabel.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor)
        ])
    }
    
    private func addAlcoholButton() {
        contentView.addSubview(alcoholButton)
        
        NSLayoutConstraint.activate([
            alcoholButton.centerYAnchor.constraint(equalTo: alcoholLabel.centerYAnchor),
            alcoholButton.trailingAnchor.constraint(equalTo: genderSegmentedControl.trailingAnchor)
        ])
    }
    
    private func addAlcoholTextView() {
        contentView.addSubview(alcoholTextView)
        
        NSLayoutConstraint.activate([
            alcoholTextView.topAnchor.constraint(equalTo: alcoholLabel.bottomAnchor,
                                                 constant: AppStyles.size.verticalMargin.small),
            alcoholTextView.leadingAnchor.constraint(equalTo: genderSegmentedControl.leadingAnchor),
            alcoholTextView.trailingAnchor.constraint(equalTo: genderSegmentedControl.trailingAnchor),
            alcoholTextView.heightAnchor.constraint(equalTo: genderSegmentedControl.heightAnchor,
                                                    multiplier: 2)
        ])
    }
    
    private func addInterestLabel() {
        contentView.addSubview(interestsLabel)
        
        NSLayoutConstraint.activate([
            interestsLabel.topAnchor.constraint(equalTo: alcoholTextView.bottomAnchor,
                                                constant: AppStyles.size.verticalMargin.middle),
            interestsLabel.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor)
        ])
    }
    
    private func addInterestsButton() {
        contentView.addSubview(interestsButton)
        
        NSLayoutConstraint.activate([
            interestsButton.centerYAnchor.constraint(equalTo: interestsLabel.centerYAnchor),
            interestsButton.trailingAnchor.constraint(equalTo: genderSegmentedControl.trailingAnchor)
        ])
    }
    
    private func addInterestTextView() {
        contentView.addSubview(interestTextView)
        
        NSLayoutConstraint.activate([
            interestTextView.topAnchor.constraint(equalTo: interestsLabel.bottomAnchor,
                                                  constant: AppStyles.size.verticalMargin.small),
            interestTextView.leadingAnchor.constraint(equalTo: genderSegmentedControl.leadingAnchor),
            interestTextView.trailingAnchor.constraint(equalTo: genderSegmentedControl.trailingAnchor),
            interestTextView.heightAnchor.constraint(equalTo: alcoholTextView.heightAnchor)
        ])
    }
    
    private func addDescribeLabel() {
        contentView.addSubview(describeLabel)
        
        NSLayoutConstraint.activate([
            describeLabel.topAnchor.constraint(equalTo: interestTextView.bottomAnchor,
                                               constant: AppStyles.size.verticalMargin.middle),
            describeLabel.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor)
        ])
    }
    
    private func addDescribeTextView() {
        contentView.addSubview(describeTextView)
        
        NSLayoutConstraint.activate([
            describeTextView.topAnchor.constraint(equalTo: describeLabel.bottomAnchor,
                                                  constant: AppStyles.size.verticalMargin.small),
            describeTextView.leadingAnchor.constraint(equalTo: genderSegmentedControl.leadingAnchor),
            describeTextView.trailingAnchor.constraint(equalTo: genderSegmentedControl.trailingAnchor),
            describeTextView.heightAnchor.constraint(equalTo: alcoholTextView.heightAnchor)
        ])
    }
    
    private func addSaveButton() {
        contentView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: describeTextView.bottomAnchor,
                                            constant: AppStyles.size.verticalMargin.middle),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -AppStyles.size.verticalMargin.small),
            saveButton.leadingAnchor.constraint(equalTo: genderSegmentedControl.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: genderSegmentedControl.trailingAnchor),
            saveButton.heightAnchor.constraint(equalTo: genderSegmentedControl.heightAnchor,
                                               multiplier: 1.5)
        ])
    }
    
    // MARK: - Methods
    
    func configureUI() {
        addScrollView()
        addAvatarImage()
        addAvatarLabel()
        addNameView()
        addUsernameLabel()
        addNameTextField()
        addNameButton()
        addBirthdayLabel()
        addDatePicker()
        addLocationLabel()
        addSetLocationButton()
        addMapIconButton()
        addGenderLabel()
        addGenderSegmenterControl()
        addSmokingLabel()
        addSmokingSegmentedControl()
        addAlcoholLabel()
        addAlcoholButton()
        addAlcoholTextView()
        addInterestLabel()
        addInterestsButton()
        addInterestTextView()
        addDescribeLabel()
        addDescribeTextView()
        addSaveButton()
        addAlcoholMenuItems()
        addInterestsMenuItems()
    }
    
    func setPropterties(userModel: User) {
        nameLabel.text = userModel.name
        birthdayDatePicker.date = Date(timeIntervalSince1970: userModel.birthDate)
        setGenderSegment(userModel.sex)
        setSmokingSegment(userModel.smoking)
        setAlcoholTextView(userModel.alcohols)
        setInterestTextView(userModel.interests)
    }
    
    private func setGenderSegment(_ sex: Sex) {
        var chooseSegment = -1
        
        switch sex {
        case .male:
           chooseSegment = 0
        case .female:
            chooseSegment = 1
        case .other:
            chooseSegment = 2
        }
        genderSegmentedControl.selectedSegmentIndex = chooseSegment
    }
    
    private func setSmokingSegment(_ smoking: Smoking) {
        var chooseSegment = -1
        
        switch smoking {
        case .smoking:
           chooseSegment = 0
        case .ok:
            chooseSegment = 1
        case .noSmoking:
            chooseSegment = 2
        }
        smokingSegmentedControl.selectedSegmentIndex = chooseSegment
    }
    
    private func setAlcoholTextView(_ alcohols: [Alcohol]) {
        guard !alcohols.isEmpty else { return }
        
        alcoholTextView.text = ""
        for (index, element) in alcohols.enumerated() {
            if index == alcohols.endIndex - 1 {
                alcoholTextView.text.append("\(element)".capitalized)
            } else {
                alcoholTextView.text.append("\(element), ".capitalized)
            }
        }
    }
    
    private func setInterestTextView(_ interests: [Interests]) {
        guard !interests.isEmpty else { return }
        
        interestTextView.text = ""
        for (index, element) in interests.enumerated() {
            if index == interests.endIndex - 1 {
                interestTextView.text.append("\(element)".capitalized)
            } else {
                interestTextView.text.append("\(element), ".capitalized)
            }
        }
    }
    
    private func addAlcoholMenuItems() {
        var childrens = [UIAction]()
        for alcohol in Alcohol.allCases {
            childrens.append(addMenuAction(title: alcohol.rawValue, forTextView: alcoholTextView))
        }
        let menuItems = UIMenu(options: .displayInline, children: childrens)
        alcoholButton.menu = menuItems
    }
    
    private func addInterestsMenuItems() {
        var childrens = [UIAction]()
        for interest in Interests.allCases {
            childrens.append(addMenuAction(title: interest.rawValue, forTextView: interestTextView))
        }
        let menuItems = UIMenu(options: .displayInline, children: childrens)
        interestsButton.menu = menuItems
    }
    
    private func addMenuAction(title: String, forTextView textView: UITextView) -> UIAction {
//        var image = UIImage()
        return UIAction(title: title.capitalized) { _ in
            print(title.capitalized)
            var text = ""
            if !textView.text.isEmpty {
                text = ", " + title.capitalized
            } else {
                text = title.capitalized
            }
            textView.text.append(text)
//            image = UIImage(named: AppData.imageName.doneIcon) ?? UIImage()
        }
    }
    
    func addLocationButtonTarget(_ target: Any, action: Selector) {
        locationButton.addTarget(target, action: action, for: .touchUpInside)
        mapIconButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func addAvatarButtonTarget(_ target: Any, action: Selector) {
        avatarButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
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
    
    func setLocation(townName: String?) {
        guard let city = townName else { return }
        locationButton.setAttributedTitle(attributedString(title: city), for: .normal)
        mapIconButton.isHidden = true
    }
    
    func presentAlertController() -> UIAlertController {
        return alertController
    }
    
    func setAvatarImage(image: UIImage) {
        avatarImageView.image = image
    }
}

// MARK: - Obj-c methods

extension ProfilePropertiesView {
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
    
    @objc func didTapNameButton() {
        if showTextField == true {
            flipView(nameLabel, nameTextField)
            nameLabel.isHidden = true
            nameTextField.isHidden = false
            showTextField = false
            nameTextField.text = nameLabel.text
            nameButton.setImage(UIImage(named: AppData.imageName.doneIcon), for: .normal)
        } else {
            nameTextField.isHidden = true
            nameLabel.isHidden = false
            flipView(nameTextField, nameLabel)
            nameLabel.text = nameTextField.text
            nameButton.setImage(UIImage(named: AppData.imageName.pencil), for: .normal)
            showTextField = true
        }
    }
}

// MARK: - Animation

extension ProfilePropertiesView {
    private func flipView(_ frontView: UIView, _ backView: UIView) {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight]
        
        UIView.transition(with: nameView, duration: 1.0, options: transitionOptions, animations: {
            frontView.isHidden = true
        })
        
        UIView.transition(with: nameView, duration: 1.0, options: transitionOptions, animations: {
            backView.isHidden = false
        })
    }
}
