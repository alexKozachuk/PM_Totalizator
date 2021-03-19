//
//  EventCollectionViewCell.swift
//  PMProject
//
//  Created by Ilya Senchukov on 19.03.2021.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var leftImageView: UIImageView?
    @IBOutlet weak var rightImageView: UIImageView?

    @IBOutlet weak var leftNameLabel: UILabel?
    @IBOutlet weak var rightNameLabel: UILabel?

    @IBOutlet weak var leftSumLabel: UILabel?
    @IBOutlet weak var rightSumLabel: UILabel?

    @IBOutlet weak var progressView: CustomProgressView?

    func setup() {
        progressView?.setup(left: 170, middle: 20, right: 280)
    }

}
