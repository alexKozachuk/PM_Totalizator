//
//  EventCollectionViewCell.swift
//  PMProject
//
//  Created by Ilya Senchukov on 19.03.2021.
//

import UIKit

// TODO: Open coments

class EventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var leftImageView: UIImageView?
    @IBOutlet weak var rightImageView: UIImageView?

    @IBOutlet weak var leftNameLabel: UILabel?
    @IBOutlet weak var rightNameLabel: UILabel?

    @IBOutlet weak var leftSumLabel: UILabel?
    @IBOutlet weak var rightSumLabel: UILabel?

    @IBOutlet weak var progressView: CustomProgressView?
    
    private let imageLoader = ImageLoader()

    func setup(with event: Event) {
        
        imageLoader.loadImage(urlString: event.firstTeam.imageUrl) { [weak self] image in
            //self.leftImageView?.image = image
        }
        
        imageLoader.loadImage(urlString: event.secondTeam.imageUrl) { [weak self] image in
            //self.rightImageView?.image = image
        }
        
        leftNameLabel?.text = event.firstTeam.name
        rightNameLabel?.text = event.secondTeam.name
        
        leftSumLabel?.text = "\(event.betSum.firstBet)"
        leftSumLabel?.text = "\(event.betSum.secondBet)"
        
        progressView?.setup(left: CGFloat(event.betSum.firstBet),
                            middle: CGFloat(event.betSum.drawBet),
                            right: CGFloat(event.betSum.secondBet))
    }

}
