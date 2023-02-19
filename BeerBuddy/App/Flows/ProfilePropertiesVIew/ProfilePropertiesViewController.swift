//
//  ProfilePropertiesViewController.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 11.02.2023.
//

import UIKit

class ProfilePropertiesViewController: UIViewController {

    private var profilePropertiesView: ProfilePropertiesView {
        guard let view = self.view as? ProfilePropertiesView else {
            let correctView = ProfilePropertiesView()
            return correctView
        }

        return view
    }
    
    var presenter: ProfilePropertiesViewOutput?
    
    // MARK: - Init
    
    init(presenter: ProfilePropertiesViewOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = profilePropertiesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePropertiesView.configureUI()
        profilePropertiesView.setLocation("Set current location")
    }
}

extension ProfilePropertiesViewController: ProfilePropertiesViewInput {
    
}
