//
//  UserCardView.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 18.02.2023.
//

import Foundation
import UIKit

class UserCardView: UIView {
    
    // MARK: - Private properties
    
    /// Initilazing view's components.
    
    private(set) lazy var contentView: UIView = {
        let view = UIView()
        view.frame.size = contentSize
        view.backgroundColor = .clear
        return view
    }()
    
    private var contentSize: CGSize {
        CGSize(
            width: frame.size.width,
            height: frame.size.height)
    }
    
    private lazy var headerView: HeaderView = {
            let view = HeaderView(title: "DISCOVER")
            view.backgroundColor = AppStyles.color.offwhite
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    private(set) lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppStyles.color.black
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private(set) lazy var userInfoView: UserInfoView = {
        let view = UserInfoView(color: AppStyles.color.offwhite)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = AppStyles.color.offwhite
        view.config(username: "USERNAME", age: 30, location: "SILICON VALLEY", noSmoking: true, noDrinking: true)
        return view
    }()
    
    private(set) lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = AppStyles.color.offwhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var interestsLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.offwhite
        label.font = AppStyles.font.title
        label.font = label.font.withSize(15)
        label.text = "INTERESTS"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var interestsListingLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.offwhite
        label.font = AppStyles.font.button
        label.font = label.font.withSize(10)
        label.text = "Football, IT, Crypto, Politics"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var aboutMyselfLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.offwhite
        label.font = AppStyles.font.title
        label.font = label.font.withSize(15)
        label.text = "ABOUT MYSELF:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var userBioLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.offwhite
        label.font = label.font.withSize(10)
        label.text = "CEO of Apple. Love beer. Cheers!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var leftButton: CustomButton = {
        let button = CustomButton(title: "SORRY")
        button.backgroundColor = AppStyles.color.sand
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var rightButton: CustomButton = {
        let button = CustomButton(title: "CHEERS!", isDarkMode: true)
        button.backgroundColor = AppStyles.color.offwhite
        button.titleLabel?.textColor = AppStyles.color.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(userAvatar: UIImage,
         interestsList: String,
         userBio: String,
         leftButtonTitle: String,
         rightButtonTitle: String) {
        super.init(frame: .zero)
        
        setupUI(
            userAvatar: userAvatar,
            interestsList: interestsList,
            userBio: userBio,
            leftButtonTitle: leftButtonTitle,
            rightButtonTitle: rightButtonTitle)
    }
    
    // MARK: - Views
    
    /// Setting up visual components.
    public func configureUI() {
        setupBackground()
        setupHeader()
        addCardView()
        addImageView()
        addUserInfoView()
        addSeparatorLine()
        addInterestsLabel()
        addInterestsListingLabel()
        addAboutMyselfLabel()
        addUserBioLabel()
        addButtonsStackView()
    }
    
    // MARK: - Private methods
    
    /// Setting up UI components.
    private func setupUI(userAvatar: UIImage,
                         interestsList: String,
                         userBio: String,
                         leftButtonTitle: String,
                         rightButtonTitle: String) {
        imageView.image = userAvatar
        interestsListingLabel.text = interestsList
        userBioLabel.text = userBio
        leftButton.titleLabel?.text = leftButtonTitle
        rightButton.titleLabel?.text = rightButtonTitle
    }
    
    private func setupBackground() {
        self.addSubview(contentView)
        backgroundColor = AppStyles.color.offwhite
    }
    
    private func setupHeader() {
        self.addSubview(headerView)
        
        headerView.setRightButton(
            imageName: AppData.imageName.slider,
            target: self,
            action: #selector(filterAction))
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: AppStyles.size.height.header)
         ])
    }
    
    private func addCardView() {
        contentView.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor,
                                          constant: AppStyles.size.verticalMargin.middle),
            cardView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cardView.widthAnchor.constraint(equalToConstant: AppStyles.size.horizontalMargin.big * 2),
            cardView.heightAnchor.constraint(greaterThanOrEqualTo: cardView.widthAnchor, multiplier: 1.5),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: AppStyles.size.horizontalMargin.small * 2),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -AppStyles.size.horizontalMargin.small * 2)
        ])
    }
    
    /// Setting up user's image.
    private func addImageView() {
        cardView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: cardView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.6),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
    }
    
    /// Setting up user information view (username, age, location, etc,).
    private func addUserInfoView() {
        cardView.addSubview(userInfoView)
            
        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(greaterThanOrEqualTo: imageView.topAnchor),
            userInfoView.heightAnchor.constraint(equalToConstant: AppStyles.size.height.header),
            userInfoView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            userInfoView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor,
                                                  constant: AppStyles.size.horizontalMargin.middle),
            userInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppStyles
                .size
                .horizontalMargin
                .big)
        ])
    }
    
    private func addSeparatorLine() {
        cardView.addSubview(separatorLine)
        
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: userInfoView.bottomAnchor,
                                               constant: AppStyles.size.verticalMargin.middle),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: cardView.leadingAnchor,
                                                   constant: AppStyles.size.verticalMargin.middle),
            separatorLine.trailingAnchor.constraint(equalTo: cardView.trailingAnchor,
                                                    constant: -AppStyles.size.verticalMargin.middle)
        ])
    }
    
    /// Setting up "Interests" label.
    private func addInterestsLabel() {
        cardView.addSubview(interestsLabel)
        
        NSLayoutConstraint.activate([
            interestsLabel.bottomAnchor.constraint(
                equalTo: separatorLine.topAnchor, constant:
                    AppStyles.size.verticalMargin.middle
                + AppStyles.size.verticalMargin.small),
            interestsLabel.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.6),
            interestsLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor,
                                                    constant:
                                                        AppStyles.size.horizontalMargin.middle
                                                    + AppStyles.size.horizontalMargin.small * 2)
        ])
    }
    
    /// Setting up user interests listing label.
    private func addInterestsListingLabel() {
        cardView.addSubview(interestsListingLabel)
        
        NSLayoutConstraint.activate([
            interestsListingLabel.bottomAnchor.constraint(equalTo: interestsLabel.bottomAnchor,
                                                          constant: AppStyles.size.verticalMargin.small * 2),
            interestsListingLabel.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.6),
            interestsListingLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor,
                                                           constant:
                                                            AppStyles.size.horizontalMargin.middle
                                                           + AppStyles.size.horizontalMargin.small * 2)
        ])
    }
    
    private func addAboutMyselfLabel() {
        cardView.addSubview(aboutMyselfLabel)
        
        NSLayoutConstraint.activate([
            aboutMyselfLabel.bottomAnchor.constraint(equalTo: interestsListingLabel.bottomAnchor,
                                                     constant:
                                                        AppStyles.size.horizontalMargin.middle
                                                     + AppStyles.size.verticalMargin.small),
            aboutMyselfLabel.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.6),
            aboutMyselfLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor,
                                                      constant:
                                                        AppStyles.size.horizontalMargin.middle
                                                      + AppStyles.size.horizontalMargin.small * 2)
        ])
    }
    
    /// Setting up user information label.
    private func addUserBioLabel() {
        cardView.addSubview(userBioLabel)
        
        NSLayoutConstraint.activate([
            userBioLabel.bottomAnchor.constraint(equalTo: aboutMyselfLabel.bottomAnchor,
                                                 constant: AppStyles.size.verticalMargin.small * 2),
            userBioLabel.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.6),
            userBioLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor,
                                                  constant:
                                                    AppStyles.size.horizontalMargin.middle
                                                  + AppStyles.size.horizontalMargin.small * 2)
        ])
    }
    
    private func addButtonsStackView() {
        cardView.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(leftButton)
        buttonsStackView.addArrangedSubview(rightButton)
        
        NSLayoutConstraint.activate([
            buttonsStackView.bottomAnchor.constraint(equalTo: userBioLabel.bottomAnchor,
                                                     constant: AppStyles.size.height.textfield),
            leftButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.33),
            rightButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.33),
            buttonsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor,
                                                     constant: -AppStyles.size.verticalMargin.middle),
            buttonsStackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    
    /// The action of the header button.
    @objc private func filterAction() {
        headerView.rightButtonClickAnimation()
        print(#function)
    }
}
