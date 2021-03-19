//
//  UICollectionView+Extension.swift
//  PMProject
//
//  Created by Sasha on 19/03/2021.
//

import UIKit

// MARK: - UIView

extension UIView {
    
    static var name: String {
        return String(describing: self)
    }
}

// MARK: - UICollectionView
extension UICollectionView {
    
    func register(type: UICollectionViewCell.Type) {
        let typeName = type.name
        let nib = UINib(nibName: typeName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: typeName)
    }
    
    func register(type: UICollectionReusableView.Type, kind: String) {
        let typeName = type.name
        let nib = UINib(nibName: typeName, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: typeName)
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.name, for: indexPath) as! T
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: type.name, for: indexPath) as! T
    }
    
}
