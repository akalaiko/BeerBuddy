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
        #if DEBUG
        let launchArguments = CommandLine.arguments
        window?.rootViewController = selectTestController(launchArguments)
        #else
        let controller = UINavigationController(rootViewController: AppModuleBuilder.onboardingViewController())
        controller.modalPresentationStyle = .fullScreen
        window?.rootViewController = controller
        #endif
        window?.makeKeyAndVisible()

        FirebaseApp.configure()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Forced synchronization of new data when minimizing the application. Since the user can close the application.
        UserDefaults.standard.synchronize()
    }
}

// MARK: - UI Testing

#if DEBUG
extension AppDelegate {
    /// Selecting a controller based on launch arguments.
    /// - Parameter arguments: Launch Arguments.
    /// - Returns: Controller.
    private func selectTestController(_ arguments: [String] ) -> UIViewController {
        let controller: UIViewController
        // TODO: Починить тесты(написать новый мок)
        /*
        if arguments.contains(AppUITestsLaunchArguments.matchesView) {
            controller = AppUITestBuilder.matchesController()
        } else if arguments.contains(AppUITestsLaunchArguments.chatsView) {
            resetUserDefaults()
            controller = AppUITestBuilder.chatsController()
        } else {
            controller = UINavigationController(rootViewController: AppModuleBuilder.onboardingViewController())
        }
         */

        controller = UINavigationController(rootViewController: AppModuleBuilder.onboardingViewController())

        return controller
    }

    /// Clearing UserDefaults.
    private func resetUserDefaults() {
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
}
#endif
