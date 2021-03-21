//
//  EventsCollectionViewDataSource.swift
//  PMProject
//
//  Created by Ilya Senchukov on 19.03.2021.
//

import UIKit

class EventsCollectionViewDataSource: NSObject {

    weak var coordinator: MainCoordinator?
    
    var items: [Event] = []
    
}

extension EventsCollectionViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: EventCollectionViewCell.self, for: indexPath)
    }
    
}

extension EventsCollectionViewDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 100, height: collectionView.frame.height - 40)
    }

}

extension EventsCollectionViewDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        coordinator?.presentDetailFeed(with: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? EventCollectionViewCell else { return }
        let item = items[indexPath.row]
        cell.setup(with: item)
    }
    
}
