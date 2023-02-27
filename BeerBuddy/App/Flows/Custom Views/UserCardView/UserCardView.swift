//
//  UserCardView.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 22.02.2023.
//

import Foundation
import UIKit

class UserCardView: UIView {
    
    // MARK: - Private properties
    
    /// Initilazing view's components.
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppStyles.color.black
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let avatarImage = "avatar"
        imageView.image = UIImage(named: avatarImage)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var userInfoView: UserInfoView = {
        let view = UserInfoView(color: AppStyles.color.offwhite)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.config(username: "USERNAME", age: 30, location: "SILICON VALLEY", noSmoking: true, noDrinking: true)
        return view
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private lazy var interestsLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.offwhite
        label.font = AppStyles.font.title
        label.font = AppStyles.font.bigTextCard
        label.text = "INTERESTS"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var interestsListingLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.offwhite
        label.font = AppStyles.font.button
        label.font = AppStyles.font.smallTextCard
        label.text = "Football, IT, Crypto, Politics"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var aboutMyselfLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.offwhite
        label.font = AppStyles.font.title
        label.font = AppStyles.font.bigTextCard
        label.text = "ABOUT MYSELF:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userBioLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.offwhite
        label.font = AppStyles.font.smallTextCard
        label.text = "CEO of Apple. Love beer. Cheers!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var rejectButton: CustomButton = {
        let button = CustomButton(title: "SORRY")
        button.backgroundColor = AppStyles.color.sand
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var acceptButton: CustomButton = {
        let button = CustomButton(title: "CHEERS!", isDarkMode: true)
        button.backgroundColor = AppStyles.color.offwhite
        button.titleLabel?.textColor = AppStyles.color.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareForReuse()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    
    /// Setting up visual components.
    public func configureUI() {
        addCardView()
        addImageView()
        addUserInfoView()
        addLabels()
        addButtons()
    }
    
    // MARK: - Public Methods
    
    func configure(userAvatar: UIImage,
                   interestsList: String,
                   userBio: String,
                   rejectButtonTitle: String,
                   acceptButtonTitle: String,
                   name: String,
                   age: Int) {
        imageView.image = userAvatar
        interestsListingLabel.text = interestsList
        userBioLabel.text = userBio
        rejectButton.setTitle(rejectButtonTitle, for: .normal)
        acceptButton.setTitle(acceptButtonTitle, for: .normal)
        
        userInfoView.config(username: name.uppercased(),
                            age: age,
                            location: "SILICON VALLEY",
                            noSmoking: false,
                            noDrinking: false)
    }
    
    // MARK: - Private methods
    
    private func prepareForReuse() {
        imageView.image = nil
        interestsListingLabel.text = nil
        userBioLabel.text = nil
        rejectButton.titleLabel?.text = nil
        acceptButton.titleLabel?.text = nil
    }
    
    private func addCardView() {
        self.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                          constant: AppStyles.size.verticalMargin.middle),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppStyles.size.verticalMargin.middle),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: AppStyles.size.horizontalMargin.middle),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -AppStyles.size.horizontalMargin.middle)
        ])
    }
    
    /// Setting up user's image.
    private func addImageView() {
        cardView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: cardView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
        ])
    }
    
    /// Setting up user information view (username, age, location, etc,).
    private func addUserInfoView() {
        cardView.addSubview(userInfoView)
            
        NSLayoutConstraint.activate([
            userInfoView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,
                                                 constant: -AppStyles.size.verticalMargin.small),
            userInfoView.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.9),
            userInfoView.heightAnchor.constraint(equalTo: userInfoView.widthAnchor, multiplier: 0.25),
            userInfoView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }
    
    /// Setting up view which consists of stack views with user interests and bio labels.
    private func addLabels() {
        cardView.addSubview(separatorLine)
        cardView.addSubview(interestsLabel)
        cardView.addSubview(interestsListingLabel)
        cardView.addSubview(aboutMyselfLabel)
        cardView.addSubview(userBioLabel)
        
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                               constant: AppStyles.size.verticalMargin.small * 2),
            separatorLine.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.9),
            separatorLine.heightAnchor.constraint(equalToConstant: 2),
            separatorLine.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            
            interestsLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor,
                                                constant: AppStyles.size.verticalMargin.middle),
            interestsLabel.leadingAnchor.constraint(equalTo: separatorLine.leadingAnchor),
            
            interestsListingLabel.topAnchor.constraint(equalTo: interestsLabel.bottomAnchor, constant: 5),
            interestsListingLabel.leadingAnchor.constraint(equalTo: interestsLabel.leadingAnchor),
            
            aboutMyselfLabel.topAnchor.constraint(equalTo: interestsListingLabel.bottomAnchor,
                                                  constant: AppStyles.size.verticalMargin.small),
            aboutMyselfLabel.leadingAnchor.constraint(equalTo: interestsListingLabel.leadingAnchor),
            
            userBioLabel.topAnchor.constraint(equalTo: aboutMyselfLabel.bottomAnchor, constant: 5),
            userBioLabel.leadingAnchor.constraint(equalTo: aboutMyselfLabel.leadingAnchor)
        ])
    }
    
    private func addButtons() {
        cardView.addSubview(rejectButton)
        cardView.addSubview(acceptButton)
        
        NSLayoutConstraint.activate([
            rejectButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            rejectButton.topAnchor.constraint(greaterThanOrEqualTo: userBioLabel.bottomAnchor, constant: 5),
            rejectButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.4),
            rejectButton.heightAnchor.constraint(equalTo: rejectButton.widthAnchor, multiplier: 0.3),
            rejectButton.trailingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: -10),

            acceptButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            acceptButton.topAnchor.constraint(greaterThanOrEqualTo: userBioLabel.bottomAnchor, constant: 5),
            acceptButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.4),
            acceptButton.heightAnchor.constraint(equalTo: acceptButton.widthAnchor, multiplier: 0.3),
            acceptButton.leadingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: 10)
        ])
    }
}
