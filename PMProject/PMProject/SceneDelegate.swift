//
//  SceneDelegate.swift
//  PMProject
//
//  Created by Sasha on 18/03/2021.
//

import UIKit
import PMTotalizator

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navController)

        coordinator?.start()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navController
        self.window = window

        window.makeKeyAndVisible()
    }
}

