//
//  ProfileViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import UIKit
import TotalizatorNetworkLayer

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView?

    weak var coordinator: MainCoordinator?

    private let authManager = AuthorizationManager()

    private var dataSource: ProfileCollectionViewDataSource?

    var networkManager: NetworkManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()

        setupCollectionView()

        fetchBetsHistory()
    }

    @objc func logout() {
        authManager.logout() { [weak self] error in
            guard error == nil else {
                print(error!)
                return
            }

            self?.coordinator?.popBack()
        }
    }
}

private extension ProfileViewController {

    func fetchBetsHistory() {
//        guard let networkManager = networkManager else {
//            return
//        }
//
//        networkManager.getBets { [weak self] res in
//            switch res {
//                case .failure(let error):
//                    print(error)
//                case .success(let bets):
//                    self?.dataSource?.bets = bets.map { Bet(bet: $0) }
//                    self?.collectionView?.reloadData()
//            }
//        }

        let bets = [
            Bet(accountID: "Test", eventID: "Test", choice: .w1, amount: 100),
            Bet(accountID: "Test", eventID: "Test", choice: .w1, amount: 100),
            Bet(accountID: "Test", eventID: "Test", choice: .w1, amount: 100),
            Bet(accountID: "Test", eventID: "Test", choice: .w1, amount: 100),
            Bet(accountID: "Test", eventID: "Test", choice: .w1, amount: 100)
        ]

        dataSource?.bets = bets
        collectionView?.reloadData()
        print("Reloaded")
    }
}

private extension ProfileViewController {

    func setupNavbar() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        navigationItem.setRightBarButton(logoutButton, animated: true)
    }

    func setupCollectionView() {
        dataSource = ProfileCollectionViewDataSource()
        collectionView?.dataSource = dataSource
        collectionView?.delegate = dataSource

        collectionView?.register(type: BetHistoryCollectionViewCell.self)
    }
}
