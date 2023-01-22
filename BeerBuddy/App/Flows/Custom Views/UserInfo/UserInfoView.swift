//
//  UserInfoView.swift
//  BeerBuddy
//
//  Created by Ke4a on 17.01.2023.
//

import UIKit

extension UserInfoView {
    enum Warning {
        case noSmoking
        case noDrinking
    }
}

/// Displays information about the user (username, age, location, warnings).
///
/// Prepared for reuse in tables and collections.
class UserInfoView: UIView {
    // MARK: - Visual Components

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = AppStyles.font.username
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: usernameLabel.font.pointSize, weight: .light)
        label.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var locationImageView: UIImageView = {
        let image = UIImage(named: AppData.imageName.location)
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var warningIconStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.spacing = 4
        return stack
    }()

    // MARK: - Initialization

    /// Creates view information about the user (username, age, location, warnings).
    /// - Parameter color: Color information.
    init(color: UIColor = .black ) {
        super.init(frame: .zero)

        setupUI(color)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings visual components.
    private func setupUI(_ color: UIColor) {
        usernameLabel.textColor = color
        ageLabel.textColor = color
        locationLabel.textColor = color
        locationImageView.tintColor = color

        let indent: CGFloat = 4

        addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.topAnchor.constraint(equalTo: usernameLabel.topAnchor),
            ageLabel.bottomAnchor.constraint(equalTo: usernameLabel.bottomAnchor),
            ageLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: indent)
        ])

        addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: indent),
            locationLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])

        addSubview(locationImageView)
        NSLayoutConstraint.activate([
            locationImageView.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor, constant: 1),
            locationImageView.trailingAnchor.constraint(equalTo: locationLabel.leadingAnchor,
                                                        constant: -AppStyles.size.horizontalMargin.small),
            // FIXME: если использовать locationLabel.heightAnchor, почему то растягивается locationLabel на максимальную высоту.
            // locationImageView.heightAnchor.constraint(equalTo: locationLabel.heightAnchor)
            locationImageView.heightAnchor.constraint(equalToConstant: locationLabel.font.pointSize),
            locationImageView.widthAnchor.constraint(equalTo: locationImageView.heightAnchor)
        ])

        addSubview(warningIconStackView)
        NSLayoutConstraint.activate([
            warningIconStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            warningIconStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            warningIconStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            warningIconStackView.leadingAnchor.constraint(greaterThanOrEqualTo: ageLabel.trailingAnchor,
                                                          constant: AppStyles.size.horizontalMargin.small),
            warningIconStackView.leadingAnchor.constraint(greaterThanOrEqualTo: locationLabel.trailingAnchor,
                                                          constant: AppStyles.size.horizontalMargin.small),
            warningIconStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }

    // MARK: - Public Methods

    /// Prepares a reusable.
    func prepareForReuse() {
        usernameLabel.text = nil
        ageLabel.text = nil
        locationLabel.text = nil

        warningIconStackView.arrangedSubviews.forEach { view in
            warningIconStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    /// Filling the component data.
    /// - Parameters:
    ///   - username: Username text.
    ///   - age: Username text.
    ///   - location: Username text.
    ///   - noSmoking: If the person does not smoke, the warning icon warning. By default, there is no warning.
    ///   - noDrinking: If the person does not drink, the warning icon warning. By default, there is no warning.
    func config(username: String, age: Int, location: String, noSmoking: Bool = false, noDrinking: Bool = false) {
        usernameLabel.text = username + ","
        ageLabel.text = String(age)
        locationLabel.text = location

        if noSmoking {
            setWarningIcon(.noSmoking)
        }

        if noDrinking {
            setWarningIcon(.noDrinking)
        }
    }

    // MARK: - Private Methods

    /// Adds a warning icon to the stack.
    /// - Parameter warning: Warning.
    private func setWarningIcon(_ warning: Warning) {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = locationLabel.textColor

        switch warning {
        case .noSmoking:
            image.image = UIImage(named: AppData.imageName.noSmoking)
        case .noDrinking:
            image.image = UIImage(named: AppData.imageName.noDrinking)
        }

        warningIconStackView.addArrangedSubview(image)
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.33),
            image.heightAnchor.constraint(equalTo: image.widthAnchor)
        ])
    }
}
