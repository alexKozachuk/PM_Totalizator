//
//  FeedViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import UIKit
import TotalizatorNetworkLayer

class FeedViewController: BalanceProvidingViewController {

    private let authManager = AuthorizationManager()
    private let networkManager = NetworkManager()

    private var eventsDataSource: EventsCollectionViewDataSource?

    @IBOutlet weak var eventsCollectionView: UICollectionView?
    @IBOutlet weak var eventsLoaderIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
        setupCollectionView()
        setupData()
    }

    // MARK: - BalanceProviderDelegate
    override func update(balance: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let navigationItem = self?.navigationItem else {
                return
            }

            self?.coordinator?.displayWallet(navigationItem: navigationItem)
        }
    }
}

private extension FeedViewController {

    @objc func profileButtonTapped() {
        coordinator?.presentProfileOrAuthorizationPage()
    }
}

private extension FeedViewController {

    func setupCollectionView() {
        eventsDataSource = EventsCollectionViewDataSource()
        eventsDataSource?.coordinator = coordinator

        eventsCollectionView?.dataSource = eventsDataSource
        eventsCollectionView?.delegate = eventsDataSource

        eventsCollectionView?.register(type: EventCollectionViewCell.self)
    }
    
    func setupData() {
        self.showLoaderEvent()
        networkManager.feed { [weak self] feed, error in
            DispatchQueue.main.async {
                self?.hideLoaderEvent()
            }
            if let error = error {
                print(error)
                return
            }
            guard let feed = feed else { return }
            
            self?.eventsDataSource?.items = feed.events.map {Event(event: $0)}
            DispatchQueue.main.async {
                self?.eventsCollectionView?.reloadData()
            }
        }
        
    }
}

// MARK: - Navigation bar setup
private extension FeedViewController {

    func setupNavbar() {
        setupLogo()
        coordinator?.displayWallet(navigationItem: navigationItem)
    }

    func setupLogo() {
        let logoImage = UIImageView(image: UIImage(named: "pm_logo"))
        let barButton = UIBarButtonItem(customView: logoImage)

        barButton.customView?.widthAnchor.constraint(equalToConstant: 80).isActive = true
        barButton.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true

        navigationItem.setLeftBarButton(barButton, animated: true)
    }
    
}

// MARK: Events Loader Indicator Methods

private extension FeedViewController {
    
    func showLoaderEvent() {
        eventsLoaderIndicator?.isHidden = false
        eventsLoaderIndicator?.startAnimating()
    }
    
    func hideLoaderEvent() {
        eventsLoaderIndicator?.isHidden = true
        eventsLoaderIndicator?.stopAnimating()
    }
    
}

