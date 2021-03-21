//
//  DetailInfoCollectionViewCell.swift
//  PMProject
//
//  Created by Sasha on 19/03/2021.
//

import UIKit

class DetailInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var leftValueLabel: UILabel?
    @IBOutlet weak var rightValueLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    
    func setup(with item: CharacteristicsPair) {
        
        leftValueLabel?.text = item.firstValue
        rightValueLabel?.text = item.secondValue
        nameLabel?.text = item.name
        
    }

}
