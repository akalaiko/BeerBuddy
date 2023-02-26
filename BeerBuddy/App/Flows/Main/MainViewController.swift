//
//  MainViewController.swift
//  BeerBuddy
//
//  Created by Ke4a on 25.01.2023.
//

import Foundation
import UIKit

final class MainViewController: UIViewController {
    // MARK: - Visual Components

    private lazy var footer: UIView = {
        let view = UIView()
        view.backgroundColor = AppStyles.color.swamp
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var tabBar: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.backgroundColor = AppStyles.color.swamp
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Private Properties

    /// Controllers that can be shown (if selected).
    private lazy var controllers: [UIViewController] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFooter()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard controllers.isEmpty else { return }
        setupControllers()
    }

    // MARK: - Setting UI Methods

    /// Setting up the visual of the footer.
    ///
    /// Adds custom tabbar.
    private func setupFooter() {
        view.backgroundColor = AppStyles.color.light

        view.addSubview(footer)
        NSLayoutConstraint.activate([
            footer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        footer.addSubview(tabBar)
        NSLayoutConstraint.activate([
            tabBar.heightAnchor.constraint(equalToConstant: AppStyles.size.height.footer),
            tabBar.topAnchor.constraint(equalTo: footer.topAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: footer.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: footer.trailingAnchor)
        ])
    }
    // MARK: - Private Methods

    /// Adds the selected controllers to the controller array. Displays the starting controller on the screen.
    private func setupControllers() {
        
        controllers = [
            createController(with: AppModuleBuilder.matchesController, imageName: AppData.imageName.search),
            createController(with: AppModuleBuilder.matchesController, imageName: AppData.imageName.beer),
            createController(with: AppModuleBuilder.chatsController, imageName: AppData.imageName.message),
            createController(with: AppModuleBuilder.profilePropertiesViewController,
                             imageName: AppData.imageName.settings)
        ]

        guard let controller = controllers.first else { return }
        showController(controller)
    }

    /// Creates a controller and binds its index to the button tag.
    /// - Parameters:
    ///   - controller: The method that returns the controller.
    ///   - imageName: Image name. You can use both the symbol and the image from the Asset.
    /// - Returns: The controller that will be shown on the screen when you switch the buttons on the tab bar.
    private func createController(with controller: () -> UIViewController, imageName: String) -> UIViewController {
        let index = tabBar.arrangedSubviews.count

        let button = createButton(imageName: imageName)
        button.tag = index
        if index == 0 {
            button.tintColor = .white
        }
        tabBar.addArrangedSubview(button)

        let vc = controller()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }

    /// Creates  button tabbar to which you will need to in the tag bind the index of the associated controller .
    /// - Parameter imageName: You can use both the symbol and the image from the Asset.
    /// - Returns: Button.
    private func createButton(imageName: String) -> UIButton {
        let button = UIButton()
        let image = UIImage(named: imageName)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill

        let isBigFooter = view.safeAreaInsets.bottom > 0
        let middleMargin = AppStyles.size.verticalMargin.middle
        let smallMargin = AppStyles.size.verticalMargin.small

        button.imageEdgeInsets = UIEdgeInsets(top: isBigFooter ? middleMargin : smallMargin,
                                              left: 0,
                                              bottom: isBigFooter ? 0 : smallMargin,
                                              right: 0)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(tabBarButtonAction), for: .touchUpInside)
        return button
    }

    /// Shows the view of the selected controller on the screen.
    /// - Parameter childController: Child controller.
    private func showController(_ childController: UIViewController) {
        addChild(childController)
        view.addSubview(childController.view)
        NSLayoutConstraint.activate([
            childController.view.topAnchor.constraint(equalTo: view.topAnchor),
            childController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childController.view.bottomAnchor.constraint(equalTo: footer.topAnchor)
        ])
        childController.didMove(toParent: self)
    }

    /// Hides the selected controller from the screen.
    /// - Parameter controller: Child controller.
    private func hideController(_ childController: UIViewController) {
        childController.willMove(toParent: self)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }

    // MARK: - Actions

    /// TabBar button action
    /// - Parameter sender: TabBar button.
    ///
    /// Shows the controller view selected by index, hiding the old view.
    @objc func tabBarButtonAction(sender: UIButton) {
        let indexButton = sender.tag

        tabBar.arrangedSubviews.enumerated().forEach { index, button in
            button.tintColor = indexButton == index ? .white : .lightGray
        }

        children.forEach(hideController)
        let controller = controllers[indexButton]
        showController(controller)
    }
}
