//
//  ProfileCollectionViewDataSource.swift
//  PMProject
//
//  Created by Ilya Senchukov on 26.03.2021.
//

import UIKit

class ProfileCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    var bets: [Bet] = []

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: BetHistoryCollectionViewCell.self, for: indexPath)
    }

}

extension ProfileCollectionViewDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}

extension ProfileCollectionViewDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? BetHistoryCollectionViewCell else { return }
        let bet = bets[indexPath.item]
        cell.setup(bet: bet)
    }
    
}
