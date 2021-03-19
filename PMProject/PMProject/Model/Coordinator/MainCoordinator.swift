//
//  MainCoordinator.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import UIKit

class MainCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private let authManager = AuthorizationManager()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mainViewController = FeedViewController()
        mainViewController.coordinator = self

        navigationController.viewControllers = [mainViewController]
    }

    func presentProfileOrAuthorizationPage() {
        if authManager.isLoggedIn() {
            let profileVC = ProfileViewController()
            profileVC.coordinator = self
            navigationController.pushViewController(profileVC, animated: true)
        } else {
            let loginVC = LoginViewController()
            loginVC.coordinator = self

            navigationController.pushViewController(loginVC, animated: true)
        }
    }

}

extension MainCoordinator {
    func popBack<T: UIViewController>(to controllerType: T.Type) {
        let viewControllers: [UIViewController] = self.navigationController.viewControllers
        if let viewController = viewControllers.last(where: { $0.isKind(of: controllerType) }) {
            self.navigationController.popToViewController(viewController, animated: true)
        }
    }

    func popBack() {
        navigationController.popViewController(animated: true)
    }

    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
