//
//  OnboardingView.swift
//  BeerBuddy
//
//  Created by Tim on 15.02.2023.
//

import Foundation
import UIKit

final class OnboardingView: UIView {
    
    // MARK: - Private properties
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: AppData.imageName.waveBackground)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: AppData.imageName.bearLogin)
        return imageView
    }()
    
    private lazy var nameAppLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BEER BUDDY"
        label.font = AppStyles.font.logo
        label.textColor = AppStyles.color.brown
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    func configureUI() {
        setupBackground()
        addAvatarImage()
        addNameAppLabel()
        addActivityIndicator()
    }
    
    private func setupBackground() {
        self.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addAvatarImage() {
        guard let width = avatarImageView.image?.size.width,
              let height = avatarImageView.image?.size.height else { return }
        
        let multiplierHeight = height / width
        backgroundImageView.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: -30),
            avatarImageView.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 0.5),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: multiplierHeight)
        ])
    }
    
    private func addNameAppLabel() {
        backgroundImageView.addSubview(nameAppLabel)
        
        NSLayoutConstraint.activate([
            nameAppLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            nameAppLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor,
                                              constant: AppStyles.size.verticalMargin.small)
        ])
    }
    
    private func addActivityIndicator() {
        backgroundImageView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: nameAppLabel.bottomAnchor,
                                                   constant: AppStyles.size.verticalMargin.small)
        ])
    }
    
}
