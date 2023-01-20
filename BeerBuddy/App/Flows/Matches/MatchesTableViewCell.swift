//
//  MatchesTableViewCell.swift
//  BeerBuddy
//
//  Created by Ke4a on 16.01.2023.
//

import UIKit

/// The cell that contains the avatar and information about the user.
class MatchesTableViewCell: UITableViewCell {
    // MARK: - Visual Components

    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var userInfoView: UserInfoView = {
        let view = UserInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Static Methods

    /// Cell identifier.
    static let identifier = "MatchesTableViewCell"

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Methods

    override func prepareForReuse() {
        super.prepareForReuse()

        avatarImageView.image = nil
        userInfoView.prepareForReuse()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        circleAvatar()
    }

    // MARK: - Setting UI Methods

    /// Settings  visual components.
    private func setupUI() {
        backgroundColor = AppStyles.color.background.main

        contentView.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                 constant: AppStyles.size.verticalMargin.small),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                    constant: -AppStyles.size.verticalMargin.small),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                     constant: AppStyles.size.horizontalMargin.middle),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor)
        ])

        contentView.addSubview(userInfoView)
        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            userInfoView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            userInfoView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor,
                                                  constant: AppStyles.size.horizontalMargin.small),
            userInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -AppStyles.size.horizontalMargin.middle)
        ])
    }

    // MARK: - Public Methods

    /// Settings the cell data.
    /// - Parameter user: User informations.
    func configure(_ user: UserTest) {
        avatarImageView.image = UIImage(named: AppData.imageName.testAvatar)
        userInfoView.config(username: user.username,
                            age: user.age,
                            location: user.location,
                            noSmoking: user.noSmoking,
                            noDrinking: user.noDrinking)
    }

    // MARK: - Private Methods

    /// Makes the avatar circular.
    private func  circleAvatar() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
    }
}
