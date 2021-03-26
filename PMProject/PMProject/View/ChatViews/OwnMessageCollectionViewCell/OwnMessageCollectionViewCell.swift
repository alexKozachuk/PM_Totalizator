//
//  OwnMessageCollectionViewCell.swift
//  PMProject
//
//  Created by Sasha on 24/03/2021.
//

import UIKit

class OwnMessageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var avatarImageView: UIImageView?
    private var imageLoader = ImageLoader()
    
    var message: String? {
        get {
            messageLabel?.text
        }
        set {
            messageLabel?.text = newValue
        }
    }
    
    var title: String? {
        get {
            titleLabel?.text
        }
        set {
            titleLabel?.text = newValue
        }
    }
    
    func setAvatar(url: String) {
        
        imageLoader.loadImage(urlString: url) { [weak self] image in
            self?.avatarImageView?.image = image
        }
        
    }
    
    // 70 is sum of margins
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        messageLabel?.preferredMaxLayoutWidth = layoutAttributes.size.width - 70
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }

}
