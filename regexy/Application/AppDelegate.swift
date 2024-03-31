//
//  AppDelegate.swift
//  regexy
//
//  Created by Augusto Avelino on 19/03/24.
//

import CoreData
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RegexData")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let dao = RegexDAO()
        dao.context = persistentContainer.viewContext
        window?.rootViewController = UINavigationController(rootViewController: RegexViewController(dao: dao))
        window?.makeKeyAndVisible()
        return true
    }
}
