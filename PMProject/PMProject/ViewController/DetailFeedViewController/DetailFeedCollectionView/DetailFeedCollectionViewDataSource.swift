//
//  DetailFeedCollectionViewDataSource.swift
//  PMProject
//
//  Created by Sasha on 19/03/2021.
//

import UIKit

class DetailFeedCollectionViewDataSource: NSObject {

    weak var coordinator: MainCoordinator?

    private let transitioningDelegate = ModalTransition()
    
    var event: Event?
    
    var detailHeight: CGFloat {
        guard let event = event else { return 0 }
        
        if event.isLive {
            return 320
        } else {
            return 540
        }
        
    }
    
    var items: [CharacteristicsPair] {
        guard let event = event else { return [] }
        var values: [CharacteristicsPair] = []
        let first = event.firstTeam.characteristics
        let second = event.secondTeam.characteristics
        
        first.forEach { key, value in
            values.append(CharacteristicsPair(name: key,
                                              firstValue: value,
                                              secondValue: second[key] ?? ""))
        }
        return values
    }

}

extension DetailFeedCollectionViewDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? DetailInfoCollectionViewCell else { return }
        let item = items[indexPath.row]
        cell.setup(with: item)
    }
    
}

extension DetailFeedCollectionViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: DetailInfoCollectionViewCell.self, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, with: DetailFeedCollectionReusableView.self, for: indexPath)
            
            if let event = event {
                reusableView.setup(with: event)
                reusableView.delegate = self
            }
            
            return reusableView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
}

extension DetailFeedCollectionViewDataSource: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: detailHeight)
    }
}

extension DetailFeedCollectionViewDataSource: DetailFeedCollectionReusableViewDelegate {

    func leftBetButtonDidTapped() {
        presentModal()
    }

    func rightBetButtonDidTapped() {
        presentModal()
    }

    func drawBetButtonDidTapped() {
        presentModal()
    }

    private func presentModal() {
        let betModal = BetModalViewController()

        betModal.transitioningDelegate = transitioningDelegate
        betModal.modalPresentationStyle = .custom

        coordinator?.navigationController.present(betModal, animated: true, completion: nil)
    }

}
