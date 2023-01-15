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
        window?.rootViewController = AppModuleBuilder.loginViewController()
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        return true
    }
}
