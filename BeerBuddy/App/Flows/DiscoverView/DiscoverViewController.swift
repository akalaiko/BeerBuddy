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
    
    /// Controller's presenter.
    private var presenter: DiscoverViewOutput?
    
    // MARK: - Initialization
    
    /// Created controller screen "Discover".
    /// - Parameter presenter : Controller's presenter.
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    // MARK: - Private methods
    
    private func setupActionForButton() {
        userCardView.rightButton.addTarget(self, action: #selector(self.didTapCheersButton), for: .touchUpInside)
        userCardView.leftButton.addTarget(self, action: #selector(self.didTapSorryButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func didTapSorryButton(sender: UIButton) {
        presenter?.didTapSorryButton()
    }
    
    @objc func didTapCheersButton(sender: UIButton) {
        presenter?.didTapCheersButton()
    }
}

//MARK: - Extensions

extension DiscoverViewController: DiscoverViewInput { }

