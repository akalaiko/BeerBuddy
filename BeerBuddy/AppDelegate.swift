//
//  AppDelegate.swift
//  BeerBuddy
//
//  Created by Tim on 10.01.2023.
//
import FirebaseCore
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let launchArguments = CommandLine.arguments

        window?.rootViewController = selectTestController(launchArguments)
        window?.makeKeyAndVisible()

        FirebaseApp.configure()
        return true
    }

    /// Selecting a controller based on launch arguments.
    /// - Parameter arguments: Launch Arguments.
    /// - Returns: Controller.
    private func selectTestController(_ arguments: [String] ) -> UIViewController {
        let controller: UIViewController

        if arguments.contains(AppUITestsLaunchArguments.matchesView) {
            controller = AppModuleBuilder.matchesController()
        } else {
            controller = AppModuleBuilder.loginViewController()
        }

        return controller
    }
}