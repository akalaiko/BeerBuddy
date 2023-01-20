//
//  MainViewController.swift
//  BeerBuddy
//
//  Created by Ke4a on 10.01.2023.
//

import UIKit

final class MainViewController: UITabBarController {
    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setting UI Methods

    /// Settings visual components.
    private func setupUI() {
        // tabBar.isTranslucent = false
        self.view.backgroundColor = AppStyles.color.background.main
    }

    // MARK: - Private Methods

    /// Adds items (controllers) to the tab bar.
    ///
    /// According to the settings from the namespace
    private func setItems() {
        self.viewControllers = AppData.screen.main.items.map { title, imageName, controller in
            let vc = controller()

            let image = UIImage(named: imageName)
            vc.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
            return UINavigationController(rootViewController: vc)
        }
    }
}
