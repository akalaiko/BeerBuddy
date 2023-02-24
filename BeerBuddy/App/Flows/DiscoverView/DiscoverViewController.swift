//
//  DiscoverViewController.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 18.02.2023.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var userCardView: DiscoverView {
        guard
            let view = self.view as? DiscoverView
        else {
            let correctView = DiscoverView()
            self.view = correctView
            return correctView
        }
        return view
    }
    
    private var presenter: DiscoverViewOutput?
    
    // MARK: - Initialization
    
    init(presenter: DiscoverViewOutput) {
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
        userCardView.cardView.acceptButton.addTarget(self,
                                                     action: #selector(self.didTapAcceptButton),
                                                     for: .touchUpInside)
        userCardView.cardView.rejectButton.addTarget(self,
                                                     action: #selector(self.didTapRejectButton),
                                                     for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func didTapRejectButton(sender: UIButton) {
        presenter?.didTapRejectButton()
    }
    
    @objc func didTapAcceptButton(sender: UIButton) {
        presenter?.didTapAcceptButton()
    }
}

// MARK: - Extensions

extension DiscoverViewController: DiscoverViewInput { }
