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

        setupNavbar()
    }

    func start() {
        let mainViewController = FeedViewController()
        mainViewController.coordinator = self

        navigationController.viewControllers = [mainViewController]
    }
    
    func presentDetailFeed(with event: Event) {
        let detailFeedVC = DetailFeedViewController()
        detailFeedVC.coordinator = self
        detailFeedVC.event = event
        navigationController.pushViewController(detailFeedVC, animated: true)
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

private extension MainCoordinator {

    func setupNavbar() {
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = false

        navigationController.navigationBar.tintColor = .pmYellow
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "RobotoCondensed-Bold", size: 20.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]

        UIBarButtonItem.appearance().setTitleTextAttributes([
                NSAttributedString.Key.font: UIFont(
                    name: "RobotoCondensed-Regular",
                    size: 18)!
            ],
            for: .normal)
    }

}

