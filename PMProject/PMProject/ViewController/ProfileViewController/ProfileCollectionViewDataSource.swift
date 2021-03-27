//
//  ProfileCollectionViewDataSource.swift
//  PMProject
//
//  Created by Ilya Senchukov on 26.03.2021.
//

import UIKit

class ProfileCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    var bets: [Bet]?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bets?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(with: BetHistoryCollectionViewCell.self, for: indexPath)

        if let bets = bets {
            let bet = bets[indexPath.item]
            cell.setup(bet: bet)
        }

        return cell
    }

}

extension ProfileCollectionViewDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 125)
    }
}
