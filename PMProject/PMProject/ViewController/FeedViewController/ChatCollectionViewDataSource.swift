//
//  ChatCollectionViewDataSource.swift
//  PMProject
//
//  Created by Sasha on 24/03/2021.
//

import UIKit

class ChatCollectionViewDataSource: NSObject {

    weak var coordinator: MainCoordinator?
    
    var items: [Message] = []
    var currentId = "qwerty"
    
}

extension ChatCollectionViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        if item.userId == currentId {
            let cell = collectionView.dequeueReusableCell(with: OwnMessageCollectionViewCell.self, for: indexPath)
            cell.setAvatar(url: item.imageURL)
            cell.title = "\(item.name) \(item.date.timeString)"
            cell.message = item.text
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(with: MessageCollectionViewCell.self, for: indexPath)
            cell.setAvatar(url: item.imageURL)
            cell.title = "\(item.name) \(item.date.timeString)"
            cell.message = item.text
            return cell
        }
    }
    
}

extension ChatCollectionViewDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }

}

extension ChatCollectionViewDataSource: UICollectionViewDelegate {
    
}
