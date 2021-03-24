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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
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
    
    var avatar: UIImage? {
        get {
            avatarImageView?.image
        }
        set {
            avatarImageView?.image = newValue
        }
    }

}
