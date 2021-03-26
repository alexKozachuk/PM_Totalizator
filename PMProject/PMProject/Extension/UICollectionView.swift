//
//  UICollectionView+Extension.swift
//  PMProject
//
//  Created by Sasha on 19/03/2021.
//

import UIKit

extension UICollectionView {
    
    func register(type: UICollectionViewCell.Type) {
        let typeName = type.reuseIdentifier
        let nib = UINib(nibName: typeName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: typeName)
    }
    
    func register(type: UICollectionReusableView.Type, kind: String) {
        let typeName = type.reuseIdentifier
        let nib = UINib(nibName: typeName, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: typeName)
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
    
}
