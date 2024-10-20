//
//  SceneDelegate.swift
//  TechnicalTestExoMindMaximeGernath
//
//  Created by Gernath Maxime on 15/10/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        navigationController.viewControllers = [HomeViewController()]
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
