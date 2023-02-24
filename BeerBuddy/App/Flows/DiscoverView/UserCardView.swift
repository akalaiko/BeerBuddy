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
        let avatarImage = "avatar"
        imageView.image = UIImage(named: avatarImage)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private(set) lazy var userInfoView: UserInfoView = {
        let view = UserInfoView(color: AppStyles.color.offwhite)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.config(username: "USERNAME", age: 30, location: "SILICON VALLEY", noSmoking: true, noDrinking: true)
        return view
    }()
    
    private(set) lazy var userInterestsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private(set) lazy var userBioStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private(set) lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private(set) lazy var userInfoCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var interestsLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.offwhite
        label.font = AppStyles.font.title
        label.font = AppStyles.font.bigTextCard
        label.text = "INTERESTS"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var interestsListingLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.offwhite
        label.font = AppStyles.font.button
        label.font = AppStyles.font.smallTextCard
        label.text = "Football, IT, Crypto, Politics"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var aboutMyselfLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppStyles.color.offwhite
        label.font = AppStyles.font.title
        label.font = AppStyles.font.bigTextCard
        label.text = "ABOUT MYSELF:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var userBioLabel: UILabel = {
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
    
    private(set) lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawSeparator(rect)
    }
    
    // MARK: - Views
    
    /// Setting up visual components.
    public func configureUI() {
        addCardView()
        addImageView()
        addUserInfoView()
        addUserInfoCardView()
        addButtonsStackView()
    }
    
    // MARK: - Public Methods
    
    func configure(userAvatar: UIImage,
                   interestsList: String,
                   userBio: String,
                   rejectButtonTitle: String,
                   acceptButtonTitle: String) {
        imageView.image = userAvatar
        interestsListingLabel.text = interestsList
        userBioLabel.text = userBio
        rejectButton.setTitle(rejectButtonTitle, for: .normal)
        acceptButton.setTitle(acceptButtonTitle, for: .normal)
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
                                          constant: AppStyles.size.verticalMargin.small),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppStyles.size.verticalMargin.small),
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
            imageView.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.6),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
        ])
    }
    
    /// Setting up user information view (username, age, location, etc,).
    private func addUserInfoView() {
        cardView.addSubview(userInfoView)
            
        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(greaterThanOrEqualTo: imageView.topAnchor),
            userInfoView.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.15),
            userInfoView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            userInfoView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor,
                                                  constant: AppStyles.size.horizontalMargin.middle),
            userInfoView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -AppStyles.size.horizontalMargin.big)
        ])
    }
    
    /// Setting up view which consists of stack views with user interests and bio labels.
    private func addUserInfoCardView() {
        cardView.addSubview(userInfoCardView)
        userInfoCardView.addSubview(userInfoStackView)
        userInfoStackView.addArrangedSubview(userInterestsStackView)
        userInfoStackView.addArrangedSubview(userBioStackView)
        userInterestsStackView.addArrangedSubview(interestsLabel)
        userInterestsStackView.addArrangedSubview(interestsListingLabel)
        userBioStackView.addArrangedSubview(aboutMyselfLabel)
        userBioStackView.addArrangedSubview(userBioLabel)
        
        NSLayoutConstraint.activate([
            userInfoCardView.topAnchor.constraint(equalTo: userInfoView.bottomAnchor),
            userInfoCardView.heightAnchor.constraint(equalTo: userInfoStackView.heightAnchor),
            userInfoStackView.leadingAnchor.constraint(greaterThanOrEqualTo: userInfoCardView.trailingAnchor,
                                                       constant: AppStyles.size.horizontalMargin.middle),
            userInfoStackView.widthAnchor.constraint(equalTo: userInfoView.widthAnchor),
            userInfoStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }
    
    private func drawSeparator(_ rect: CGRect) {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(
            rect: CGRect(
                x: userInfoStackView.frame.minX,
                y: userInfoStackView.frame.width * 0.10,
                width: userInfoStackView.frame.width * 1.00,
                height: 1)).cgPath
        layer.lineWidth = 1
        layer.strokeColor = AppStyles.color.offwhite.cgColor
        userInfoCardView.layer.addSublayer(layer)
    }
    
    private func addButtonsStackView() {
        cardView.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(rejectButton)
        buttonsStackView.addArrangedSubview(acceptButton)
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: userInfoStackView.bottomAnchor,
                                                  constant: AppStyles.size.verticalMargin.middle),
            buttonsStackView.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.66),
            buttonsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor,
                                                     constant: -AppStyles.size.verticalMargin.middle),
            buttonsStackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])
    }
}
