//
//  DiscoverViewController.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 18.02.2023.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var userCardView: UserProfileView {
        guard
            let view = self.view as? UserProfileView
        else {
            let correctView = UserProfileView()
            self.view = correctView
            return correctView
        }
        return view
    }
    
    private var presenter: UserProfileViewOutput?
    
    // MARK: - Initialization
    
    init(presenter: UserProfileViewOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = userCardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCardView.configureUI(model: nil)
        setupActionForButton()
        presenter?.getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Private methods
    
    private func setupActionForButton() {
        userCardView.cardView.acceptButton.addTarget(self,
                                                     action: #selector(self.didTapEditButton),
                                                     for: .touchUpInside)
        userCardView.cardView.rejectButton.addTarget(self,
                                                     action: #selector(self.didTapLogOut),
                                                     for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func didTapLogOut(sender: UIButton) {
        presenter?.didTapLogOut()
    }
    
    @objc func didTapEditButton(sender: UIButton) {
        presenter?.didTapEditButton()
    }
}

// MARK: - Extensions

extension UserProfileViewController: UserProfileViewInput {
    func updateViewWithUserData(model: UserCardViewModel) {
        userCardView.configureUI(model: model)
    }
}
