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
    @IBOutlet weak var gradientView: UIView?
    
    @IBOutlet weak var liveImageView: UIImageView?
    
    private let imageLoader = ImageLoader()

    override func awakeFromNib() {
        setupGradientView()
    }

    func setup(with event: Event) {

        imageLoader.loadImage(urlString: event.firstTeam.imageUrl) { [weak self] image in
            self?.leftImageView?.image = image
        }
        
        imageLoader.loadImage(urlString: event.secondTeam.imageUrl) { [weak self] image in
            self?.rightImageView?.image = image
        }
        
        leftNameLabel?.text = event.firstTeam.name
        rightNameLabel?.text = event.secondTeam.name
        
        leftSumLabel?.text = "\(event.betSum.firstBet)"
        rightSumLabel?.text = "\(event.betSum.secondBet)"
        
        progressView?.setup(left: CGFloat(event.betSum.firstBet),
                            middle: CGFloat(event.betSum.drawBet),
                            right: CGFloat(event.betSum.secondBet))
        
        liveImageView?.isHidden = !event.isLive
    }

    private func setupGradientView() {
        guard let gradientView = gradientView else {
            return
        }

        gradientView.clipsToBounds = true

        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [UIColor.black.withAlphaComponent(0).cgColor,
                                UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer.frame = gradientView.bounds
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    override func prepareForReuse() {
        leftNameLabel?.text = nil
        rightNameLabel?.text = nil
        
        leftSumLabel?.text = nil
        rightSumLabel?.text = nil
        
        leftImageView?.image = #imageLiteral(resourceName: "leftImage")
        rightImageView?.image = #imageLiteral(resourceName: "rightImage")
        
        
        progressView?.setup(left: 0, middle: 1, right: 0)
        
        liveImageView?.isHidden = true
    }
}
