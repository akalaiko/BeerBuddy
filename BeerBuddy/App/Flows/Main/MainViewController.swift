//
//  MainViewController.swift
//  BeerBuddy
//
//  Created by Ke4a on 25.01.2023.
//

import Foundation
import UIKit

extension MainViewController {
    /// Сontroller data. With delayed creation of the controller only at the time of the call.
    private class ControllerData {
        lazy var data: UIViewController = {
            let controller = self.builder()
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            return controller
        }()
        let buttonImageName: String

        private let builder: () -> UIViewController

        init(builder: @escaping () -> UIViewController, buttonImageName: String) {
            self.builder = builder
            self.buttonImageName = buttonImageName
        }
    }
}

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

    /// Controllers data that can be shown (if selected).
    private lazy var controllersData: [ControllerData] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFooter()
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
        guard controllersData.isEmpty else { return }
        
        controllersData = [
            ControllerData(builder: AppModuleBuilder.matchesController, buttonImageName: AppData.imageName.search),
            ControllerData(builder: AppModuleBuilder.matchesController, buttonImageName: AppData.imageName.beer),
            ControllerData(builder: AppModuleBuilder.chatsController, buttonImageName: AppData.imageName.message),
            ControllerData(builder: AppModuleBuilder.matchesController, buttonImageName: AppData.imageName.settings)
        ]

        controllersData.enumerated().forEach { index, data in
            addButtonToTabBar(imageName: data.buttonImageName, index: index)
        }

        guard let controller = controllersData.first else { return }
        showController(controller.data)
    }

    /// Adds a controller button to the tab bar by linking it to the index.
    /// - Parameters:
    ///   - imageName: Image name. You can use both the symbol and the image from the Asset.
    ///   - index: Controller index.
    private func addButtonToTabBar(imageName: String, index: Int) {
        let button = createButton(imageName: imageName)
        button.tag = index
        if index == 0 {
            button.tintColor = .white
        }
        tabBar.addArrangedSubview(button)
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
        let controller = controllersData[indexButton]
        showController(controller.data)
    }
}
