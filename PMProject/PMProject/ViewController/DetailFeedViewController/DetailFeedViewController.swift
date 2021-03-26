//
//  DetailFeedViewController.swift
//  PMProject
//
//  Created by Sasha on 19/03/2021.
//

import UIKit
import TotalizatorNetworkLayer

class DetailFeedViewController: BalanceProvidingViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var networkManager: NetworkManager?
    var dataSource: DetailFeedCollectionViewDataSource?

    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource?.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataSource?.stopTimer()
    }

    override func update(balance: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let navigationItem = self?.navigationItem else {
                return
            }
            self?.coordinator?.displayWallet(navigationItem: navigationItem)
        }
    }
}

private extension DetailFeedViewController {

    func setupNavbar() {

        coordinator?.balanceProviderDelegate = self
        coordinator?.displayWallet(navigationItem: navigationItem)
    }

    func setupCollectionView() {
        dataSource = DetailFeedCollectionViewDataSource()
        dataSource?.coordinator = coordinator
        dataSource?.event = event
        dataSource?.collectionView = collectionView
        dataSource?.networkManager = networkManager
        
        collectionView?.dataSource = dataSource
        collectionView?.delegate = dataSource

        let kindHeader = UICollectionView.elementKindSectionHeader
        
        collectionView?.register(type: DetailInfoCollectionViewCell.self)
        collectionView?.register(type: DetailFeedCollectionReusableView.self, kind: kindHeader)

    }
}
