//
//  AppDelegate.swift
//  regexy
//
//  Created by Augusto Avelino on 19/03/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: RegexViewController())
        window?.makeKeyAndVisible()
        return true
    }
}
