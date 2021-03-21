//
//  EventsCollectionViewDataSource.swift
//  PMProject
//
//  Created by Ilya Senchukov on 19.03.2021.
//

import UIKit

class EventsCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    weak var coordinator: Coordinator?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(with: EventCollectionViewCell.self, for: indexPath)

        return cell
    }
}

extension EventsCollectionViewDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 100, height: collectionView.frame.height - 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailFeedVC = DetailFeedViewController()
        detailFeedVC.coordinator = coordinator

        coordinator?.navigationController.pushViewController(detailFeedVC, animated: true)
    }
}
