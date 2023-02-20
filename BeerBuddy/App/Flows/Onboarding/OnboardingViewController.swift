//
//  OnboardingViewController.swift
//  BeerBuddy
//
//  Created by Tim on 15.02.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var onboardingView: OnboardingView {
        guard let view = self.view as? OnboardingView else {
            let correctView = OnboardingView()
            self.view = correctView
            return correctView
        }
        return view
    }
    
    // MARK: - Properties
    
    private var presenter: OnboardingViewOutput?
    
    // MARK: - Init
    
    init(presenter: OnboardingViewOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.configureUI()
        presenter?.validateAuth()
    }

    // MARK: - Private methods

}

// MARK: - OnboardingViewInput

extension OnboardingViewController: OnboardingViewInput {
    
}
