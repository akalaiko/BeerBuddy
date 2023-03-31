//
//  UserCardView.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 18.02.2023.
//

import Foundation
import UIKit

class DiscoverView: UIView {
    
    // MARK: - Private properties
    
    /// Initilazing view's components.
    private lazy var headerView: HeaderView = {
            let view = HeaderView(title: "DISCOVER")
            view.font = AppStyles.font.big
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    private(set) lazy var cardView: UserCardView = {
        let view = UserCardView()
        view.configure(userAvatar: UIImage(named: "avatar") ?? UIImage(),
                       interestsList: "Football, IT, Crypto, Politics",
                       userBio: "CEO of Apple. Love beer. Cheers!",
                       rejectButtonTitle: "SORRY",
                       acceptButtonTitle: "CHEERS",
                       name: "USERNAME",
                       age: 30)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Views
    
    /// Setting up visual components.
    public func configureUI() {
        setupBackground()
        setupHeader()
        addCardView()
    }
    
    // MARK: - Private methods
    
    private func setupBackground() {
        backgroundColor = AppStyles.color.light
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
        self.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor,
                                          constant: AppStyles.size.verticalMargin.small),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppStyles.size.verticalMargin.small),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: - Actions

    /// The action of the header button.
    @objc private func filterAction() {
        headerView.rightButtonClickAnimation()
        print(#function)
    }
}
