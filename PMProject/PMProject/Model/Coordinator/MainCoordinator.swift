//
//  MainCoordinator.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import UIKit
import TotalizatorNetworkLayer

class MainCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController

    private let networkManager = NetworkManager()

    private lazy var authManager = AuthorizationManager(networkManager: networkManager)

    private lazy var balanceProvider = BalanceProvider(networkManager: networkManager)

    weak var balanceProviderDelegate: BalanceProviderDelegate? {
        didSet {
            balanceProvider.delegate = balanceProviderDelegate
        }
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        setupNavbar()
    }
}

// MARK: - Presenting view controllers
extension MainCoordinator {

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

// MARK: - Popping view controllers
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

// MARK: - Navigation Bar setup
extension MainCoordinator {

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
        let balance = BalanceView(balance: balanceProvider.balance)

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

    private func setupNavbar() {
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


    private func getProfilePicture() -> UIImage {
        let image = UIImage(systemName: "person.fill")!

        return image
    }

    func update() {
        balanceProviderDelegate?.update(balance: balanceProvider.balance)
    }
}

