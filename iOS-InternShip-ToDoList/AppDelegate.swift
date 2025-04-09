//
//  AppDelegate.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/18/25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        print(CoreManager.shared.readAllToDos())
        if CoreManager.shared.readAllToDos().isEmpty {
            let networkService: NetworkService = NetworkService(urlString: "https://dummyjson.com")
            DispatchQueue.main.async {
                networkService.sendRequest(path: "/todos", completion: { response in
                    response.recordToCoreData()
                    NotificationCenter.default.post(name: Notification.Name.reloadData, object: nil)
                })
            }
        }
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

