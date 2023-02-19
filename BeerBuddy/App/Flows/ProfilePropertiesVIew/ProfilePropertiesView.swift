//
//  ProfilePropertiesView.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 11.02.2023.
//

import UIKit

final class ProfilePropertiesView: UIView {
    
    // MARK: - Properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .clear
//        scrollView.addGestureRecognizer(
//            UITapGestureRecognizer(
//                target: self,
//                action: #selector(hideKeyboard)))
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var avatarLabel: UILabel = {
        let label = UILabel()
        label.text = "ADD"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "USERNAME"
        label.font = AppStyles.font.username
        label.textColor = AppStyles.color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
//        datePicker.date = Date(timeIntervalSince1970: 10000000000)
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
    
    private lazy var setLocationLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.swamp
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var mapIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AppData.imageName.mapIcon)
        imageView.tintColor = AppStyles.color.swamp
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender:"
        label.font = AppStyles.font.button
        label.textColor = AppStyles.color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genderSegmentedControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
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
    
    private lazy var smokingSegmentedControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    private lazy var alcoholLabel: UILabel = {
        let label = UILabel()
        label.text = "Alcohol preference"
        label.font = AppStyles.font.button
        label.textColor = AppStyles.color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var interestsLabel: UILabel = {
        let label = UILabel()
        label.text = "Interests"
        label.font = AppStyles.font.button
        label.textColor = AppStyles.color.black
        return label
    }()
    
    private lazy var describeLabel: UILabel = {
        let label = UILabel()
        label.text = "Describe yourself or what are you looking for?"
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
        let button = CustomButton(title: "Save")
        button.backgroundColor = AppStyles.color.swamp
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
            self.settingCornerRadiusForImage()
        }
    }
    
    private func settingCornerRadiusForImage() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
    }
    
    func configureUI() {
        self.backgroundColor = AppStyles.color.light
        addScrollView()
        addAvatarImage()
        addAvatarLabel()
        addUsernameLabel()
        addBirthdayLabel()
        addDatePicker()
        addLocationLabel()
        addSetLocationLabel()
        addMapIcon()
        addGenderLabel()
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
            avatarImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.42),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: multiplierHeight)
        ])
    }
    
    private func addAvatarLabel() {
        contentView.addSubview(avatarLabel)
        
        NSLayoutConstraint.activate([
            avatarLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor,
                                                constant: -AppStyles.size.verticalMargin.small),
            avatarLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor)
        ])
    }
    
    private func addUsernameLabel() {
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor,
                                           constant: AppStyles.size.verticalMargin.middle),
            nameLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor)
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
                                                        constant: AppStyles.size.horizontalMargin.big)
        ])
    }
    
    private func addLocationLabel() {
        contentView.addSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor,
                                               constant: AppStyles.size.verticalMargin.small),
            locationLabel.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor)
        ])
    }
    // FIXME: Change on button
    private func addSetLocationLabel() {
        contentView.addSubview(setLocationLabel)
        
        NSLayoutConstraint.activate([
            setLocationLabel.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            setLocationLabel.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor,
                                                      constant: AppStyles.size.horizontalMargin.big)
        ])
    }
    
    private func addMapIcon() {
        contentView.addSubview(mapIcon)
        
        NSLayoutConstraint.activate([
            mapIcon.leadingAnchor.constraint(equalTo: setLocationLabel.trailingAnchor,
                                             constant: AppStyles.size.horizontalMargin.small),
            mapIcon.centerYAnchor.constraint(equalTo: setLocationLabel.centerYAnchor),
            mapIcon.widthAnchor.constraint(equalToConstant: setLocationLabel.font.pointSize),
            mapIcon.heightAnchor.constraint(equalToConstant: setLocationLabel.font.pointSize)
        ])
    }
    
    private func addGenderLabel() {
        contentView.addSubview(genderLabel)
        
        NSLayoutConstraint.activate([
            genderLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor,
                                             constant: AppStyles.size.verticalMargin.small),
            genderLabel.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor)
        ])
    }
    
    func setLocation(_ string: String) {
        let atrributedString = NSAttributedString(string: string,
                                                  attributes: [
                                                    NSAttributedString.Key.underlineStyle:
                                                        NSUnderlineStyle.single.rawValue
                                                                       ])
        setLocationLabel.attributedText = atrributedString
    }
}

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
}
