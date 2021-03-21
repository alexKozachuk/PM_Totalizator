//
//  DetailFeedViewController.swift
//  PMProject
//
//  Created by Sasha on 19/03/2021.
//

import UIKit

class DetailFeedViewController: UIViewController {

    weak var coordinator: Coordinator?

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: DetailFeedCollectionViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

}

private extension DetailFeedViewController {
    
    func setupCollectionView() {
        dataSource = DetailFeedCollectionViewDataSource()
        dataSource?.coordinator = coordinator

        collectionView?.dataSource = dataSource
        collectionView?.delegate = dataSource

        let kindHeader = UICollectionView.elementKindSectionHeader
        
        collectionView?.register(type: DetailInfoCollectionViewCell.self)
        collectionView?.register(type: DetailFeedCollectionReusableView.self, kind: kindHeader)

    }
}
