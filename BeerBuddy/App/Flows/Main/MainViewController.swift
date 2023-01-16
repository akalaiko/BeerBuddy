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
        self.tabBar.backgroundColor = .white
    }

    // MARK: - Private Methods

    /// Adds items (controllers) to the tab bar.
    ///
    /// According to the settings from the namespace
    private func setItems() {
        self.viewControllers = AppData.screen.main.map { title, imageName, controller in
            let vc = controller.init()
            randomColorVc(view: vc.view)

            let image = UIImage(named: imageName)
            vc.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
            return UINavigationController(rootViewController: vc)
        }
    }
    
    // TODO: Delete after adding real screens.
    
    // For tests to show different screens in colour, the product will be removed.
    private func randomColorVc(view: UIView) {
        view.backgroundColor = UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )

    }
}
