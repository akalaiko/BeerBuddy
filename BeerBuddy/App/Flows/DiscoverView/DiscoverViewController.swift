//
//  DiscoverViewController.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 18.02.2023.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var userCardView: UserCardView {
        guard
            let view = self.view as? UserCardView
        else {
            let correctView = UserCardView(frame: self.view.frame)
            self.view = correctView
            return correctView
        }
        return view
    }
    
    private var presenter: DiscoverViewOutput?
    
    // MARK: - Initialization
    
    init(presenter: DiscoverPresenter? = nil) {
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
        userCardView.configureUI()
        setupActionForButton()
    }

    // MARK: - Private methods
    
    private func setupActionForButton() {
        userCardView.rightButton.addTarget(self, action: #selector(self.didTapRightButton), for: .touchUpInside)
        userCardView.leftButton.addTarget(self, action: #selector(self.didTapLeftButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func didTapLeftButton(sender: UIButton) {
        presenter?.didTapLeftButton()
    }
    
    @objc func didTapRightButton(sender: UIButton) {
        presenter?.didTapRightButton()
    }
}

// MARK: - Extensions

extension DiscoverViewController: DiscoverViewInput { }
