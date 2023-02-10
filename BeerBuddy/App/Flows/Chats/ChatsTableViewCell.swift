//
//  ChatsTableViewCell.swift
//  BeerBuddy
//
//  Created by Ke4a on 04.02.2023.
// swiftlint: disable function_body_length

import UIKit

class ChatsTableViewCell: UITableViewCell {
    // MARK: - Visual Components

    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = AppStyles.font.username
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = AppStyles.font.smallTextCell
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = lastMessageLabel.font
        label.textAlignment = .right
        return label
    }()

    private lazy var pinImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: AppData.imageName.pinCircle)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.tintColor = .black
        return view
    }()

    // MARK: - Static Properties

    /// Cell identifier.
    static let identifier = "ChatsTableViewCell"

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings of visual components.
    func setupUI() {
        backgroundColor = AppStyles.color.background.main

        selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = AppStyles.color.sand
            return view
        }()

        let spacing: CGFloat = 4
        contentView.addSubview(avatarImageView)

        let avatarTop = avatarImageView.topAnchor .constraint(equalTo: contentView.topAnchor,
                                                              constant: AppStyles.size.verticalMargin.small)
        avatarTop.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            avatarTop,
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                    constant: -AppStyles.size.verticalMargin.small),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                     constant: AppStyles.size.horizontalMargin.middle),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor)
        ])

        contentView.addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor,
                                                   constant: AppStyles.size.horizontalMargin.small)
        ])

        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -AppStyles.size.horizontalMargin.middle),
            dateLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: spacing)
        ])

        contentView.addSubview(lastMessageLabel)
        let lastMessageTop = lastMessageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor,
                                                                   constant: spacing)
        lastMessageTop.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            lastMessageTop,
            lastMessageLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            lastMessageLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.trailingAnchor),
            lastMessageLabel.bottomAnchor.constraint(lessThanOrEqualTo: avatarImageView.bottomAnchor)
        ])

        contentView.addSubview(pinImageView)
        NSLayoutConstraint.activate([
            pinImageView.topAnchor.constraint(lessThanOrEqualTo: usernameLabel.bottomAnchor),
            pinImageView.bottomAnchor.constraint(lessThanOrEqualTo: avatarImageView.bottomAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: lastMessageLabel.centerYAnchor),
            pinImageView.heightAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 0.38),
            pinImageView.widthAnchor.constraint(lessThanOrEqualTo: pinImageView.heightAnchor),
            pinImageView.leadingAnchor.constraint(equalTo: lastMessageLabel.trailingAnchor, constant: spacing),
            pinImageView.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor)
        ])
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        changeAvatarCircle()
    }

    // MARK: - Prepare For Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = nil
        usernameLabel.text = nil
        lastMessageLabel.text = nil
        dateLabel.text = nil
        hidePinImage(true)
    }

    // MARK: - Public Methods

    /// Cell configuration.
    /// - Parameters:
    ///   - avatar: User avatar.
    ///   - userName: User's username.
    ///   - lastMessage: Last message.
    ///   - date: Date of last post.
    ///   - pinned: If the chat is pinned, the pin image appears and the chat background color changes.
    func configure(avatar: UIImage? = nil, userName: String, lastMessage: String, date: String, pinned: Bool) {
        backgroundColor = pinned ? AppStyles.color.background.pinnedChat : AppStyles.color.background.main
        hidePinImage(!pinned)
        #if DEBUG
        setUITests(pinned)
        #endif
        avatarImageView.image = UIImage(named: AppData.imageName.testAvatar)
        usernameLabel.text = userName
        lastMessageLabel.text = lastMessage
        dateLabel.text = date
    }

    // MARK: - Private Methods

    /// Makes the avatar circular.
    private func changeAvatarCircle() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
    }

    /// Hide the pin image.
    /// - Parameter hidden: Image is hidden
    private func hidePinImage(_ hidden: Bool) {
        pinImageView.isHidden = hidden

        if hidden && pinImageView.contentCompressionResistancePriority(for: .horizontal) == .defaultHigh {
            pinImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            lastMessageLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        } else if !hidden && pinImageView.contentCompressionResistancePriority(for: .horizontal) == .defaultLow {
            pinImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            lastMessageLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
}

// MARK: - UI Testing

#if DEBUG
extension ChatsTableViewCell {
    /// Setting ui test Identifiers.
    private func setUITests(_ isPinned: Bool) {
        self.accessibilityIdentifier = "chats\(isPinned ? "Pinned" : "")Cell"
        self.pinImageView.accessibilityIdentifier = "cellPinImage"
        self.dateLabel.accessibilityIdentifier = "cellDate"
    }
}
#endif
