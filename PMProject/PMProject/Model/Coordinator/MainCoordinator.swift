//
//  MainCoordinator.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import UIKit

class CoordinatedViewController: UIViewController {

    weak var coordinator: MainCoordinator?
}

class BalanceProvidingViewController: CoordinatedViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        coordinator?.balanceNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        guard let navigationController = navigationController else {
            return
        }

        if isMovingFromParent {
            let count = navigationController.viewControllers.count

            let index = count - 1

            if navigationController.viewControllers[index] is BalanceProvidingViewController {
                return
            } else {
                coordinator?.discardBalanceFetching()
            }
        } else {
            if navigationController.viewControllers.last is BalanceProvidingViewController {
                return
            } else {
                coordinator?.discardBalanceFetching()
            }
        }
    }
}

class MainCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController

    private let authManager = AuthorizationManager()

    private let balanceProvider = BalanceProvider()

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

    @objc func presentProfileOrAuthorizationPage() {
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
    
    func presentRegistrationPage() {
        let registerVC = RegisterViewController()
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
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

    var profileBarButton: UIBarButtonItem {
        let iconLength: CGFloat = 30

        let profilePicture = getProfilePicture()

        let profileButton = UIButton()

        profileButton.setImage(profilePicture, for: .normal)
        profileButton.backgroundColor = .white
        profileButton.layer.masksToBounds = true
        profileButton.tintColor = .black

        profileButton.addTarget(self, action: #selector(presentProfileOrAuthorizationPage), for: .touchUpInside)

        let profileBarButton = UIBarButtonItem(customView: profileButton)

        profileBarButton.customView?.widthAnchor.constraint(
            equalToConstant: iconLength
        ).isActive = true
        profileBarButton.customView?.heightAnchor.constraint(
            equalToConstant: iconLength
        ).isActive = true

        profileBarButton.customView?.layer.cornerRadius = iconLength / 2

        return profileBarButton
    }

    var balanceBarItem: UIBarButtonItem {
        let balance = BalanceView()

        return balance
    }

    func displayWallet(navigationItem: UINavigationItem) {

        if authManager.isLoggedIn() {
            let stackview = UIStackView.init(arrangedSubviews: [balanceBarItem.customView!, profileBarButton.customView!])

            stackview.distribution = .equalSpacing
            stackview.axis = .horizontal
            stackview.alignment = .center
            stackview.spacing = 8

            let rightBarButton = UIBarButtonItem(customView: stackview)
            navigationItem.setRightBarButton(rightBarButton, animated: true)
        } else {
            navigationItem.setRightBarButton(profileBarButton, animated: true)
        }

    }

    func balanceNeeded() {
        balanceProvider.startTimer()
    }

    func discardBalanceFetching() {
        balanceProvider.stopTimer()
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


    func getProfilePicture() -> UIImage {
        let image = UIImage(systemName: "person.fill")!

        return image
    }
}


