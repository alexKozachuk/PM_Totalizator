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

    private var networkManager = NetworkManager()
    private var imageLoader = ImageLoader()
    private let transitioningDelegate = ModalTransition()

    lazy var authManager = AuthorizationManager(networkManager: networkManager)

    private lazy var balanceProvider = BalanceProvider(networkManager: networkManager)

    weak var balanceProviderDelegate: BalanceProviderDelegate? {
        didSet {
            balanceProvider.delegate = balanceProviderDelegate
        }
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        if let token = authManager.getToken() {
            NetworkManager.APIKey = token
            authManager.setupUserInfo()
        }

        setupNavbar()
    }
}

// MARK: - Presenting view controllers
extension MainCoordinator {

    func start() {
        let feedVC = FeedViewController()
        feedVC.networkManager = networkManager
        feedVC.authManager = authManager
        feedVC.coordinator = self

        navigationController.viewControllers = [feedVC]
    }

    func presentDetailFeed(with event: Event) {
        let detailFeedVC = DetailFeedViewController()
        detailFeedVC.networkManager = networkManager
        detailFeedVC.coordinator = self
        detailFeedVC.event = event
        navigationController.pushViewController(detailFeedVC, animated: true)
    }

    @objc func presentProfileOrAuthorizationPage() {
        if authManager.isLoggedIn() {
            let profileVC = ProfileViewController()
            profileVC.networkManager = networkManager
            profileVC.authManager = authManager
            profileVC.coordinator = self
            navigationController.pushViewController(profileVC, animated: true)
        } else {
            let loginVC = LoginViewController()
            loginVC.authManager = authManager
            loginVC.coordinator = self

            navigationController.pushViewController(loginVC, animated: true)
        }
    }

    func presentRegistrationPage() {
        let registerVC = RegisterViewController()
        registerVC.authManager = authManager
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    @objc func presentDepositPage() {
        if navigationController.viewControllers.last is DepositViewController { return }
        let depositVC = DepositViewController()
        depositVC.networkManager = networkManager
        depositVC.coordinator = self
        navigationController.pushViewController(depositVC, animated: true)
    }
    
    func presentBetModal(event: Event, delegate: BetModalDelegate, typeBet: PossibleResult) {
        let betModal = BetModalViewController()
        betModal.setup(event: event, delegate: delegate, coordinator: self, typeBet: typeBet)
        betModal.transitioningDelegate = transitioningDelegate
        betModal.modalPresentationStyle = .custom

        navigationController.present(betModal, animated: true, completion: nil)
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

        
        
        

        let profileButton = UIButton()

        getProfilePicture { image in
            DispatchQueue.main.async {
                profileButton.setImage(image, for: .normal)
            }
        }
        
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


    private func getProfilePicture(completion: @escaping (UIImage) -> Void) {
        
        if let info = authManager.userInfo {
            imageLoader.loadImage(urlString: info.avatarLink) { image in
                completion(image)
            }
        } else {
            let image = UIImage(systemName: "person.fill")!
            completion(image)
        }
       
    }
    
}

// MARK: Balance

extension MainCoordinator {
    
    var balanceBarItem: UIBarButtonItem {
        let item = BalanceView(balance: balanceProvider.balance)
        item.coordinator = self
        return item
    }

    func displayWallet(navigationItem: UINavigationItem) {

        if authManager.isLoggedIn() {
            navigationItem.setRightBarButtonItems([profileBarButton, balanceBarItem], animated: false)
        } else {
            navigationItem.setRightBarButtonItems([profileBarButton], animated: false)
        }

    }

    func balanceNeeded() {
        if authManager.isLoggedIn() {
            balanceProvider.startUpdating()
        }
    }

    func discardBalanceFetching() {
        balanceProvider.stopUpdating()
    }

    func update() {
        balanceProviderDelegate?.update(balance: balanceProvider.balance)
    }
    
}

