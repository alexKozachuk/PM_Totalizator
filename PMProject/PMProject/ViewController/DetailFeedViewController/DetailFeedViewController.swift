//
//  DetailFeedViewController.swift
//  PMProject
//
//  Created by Sasha on 19/03/2021.
//

import UIKit

class DetailFeedViewController: BalanceProvidingViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: DetailFeedCollectionViewDataSource?

    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
        setupCollectionView()
    }

    override func update(balance: Int) {
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

        collectionView?.dataSource = dataSource
        collectionView?.delegate = dataSource

        let kindHeader = UICollectionView.elementKindSectionHeader
        
        collectionView?.register(type: DetailInfoCollectionViewCell.self)
        collectionView?.register(type: DetailFeedCollectionReusableView.self, kind: kindHeader)

    }
}
