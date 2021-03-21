//
//  DetailFeedViewController.swift
//  PMProject
//
//  Created by Sasha on 19/03/2021.
//

import UIKit

class DetailFeedViewController: UIViewController {

    weak var coordinator: MainCoordinator?

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: DetailFeedCollectionViewDataSource?
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

}

private extension DetailFeedViewController {
    
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
