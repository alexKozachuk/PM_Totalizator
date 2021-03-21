//
//  DetailFeedCollectionViewDataSource.swift
//  PMProject
//
//  Created by Sasha on 19/03/2021.
//

import UIKit

class DetailFeedCollectionViewDataSource: NSObject {

    weak var coordinator: Coordinator?

    private let transitioningDelegate = ModalTransition()

}

extension DetailFeedCollectionViewDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? DetailInfoCollectionViewCell else { return }
    }
    
}

extension DetailFeedCollectionViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: DetailInfoCollectionViewCell.self, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, with: DetailFeedCollectionReusableView.self, for: indexPath)

            reusableView.setup()
            reusableView.delegate = self

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
        return CGSize(width: collectionView.frame.width, height: 540)
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
