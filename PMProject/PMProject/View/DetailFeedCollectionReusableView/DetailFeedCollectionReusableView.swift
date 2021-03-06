//
//  DetailFeedCollectionReusableView.swift
//  PMProject
//
//  Created by Sasha on 19/03/2021.
//

import UIKit

protocol DetailFeedCollectionReusableViewDelegate {
    func leftBetButtonDidTapped()
    func rightBetButtonDidTapped()
    func drawBetButtonDidTapped()
}

// TODO: Open coments

class DetailFeedCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var leftNameLabel: UILabel!
    @IBOutlet weak var rightNameLabel: UILabel!
    
    @IBOutlet weak var leftValueLabel: UILabel!
    @IBOutlet weak var rightValueLabel: UILabel!
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!

    @IBOutlet weak var progressView: CustomProgressView!
    
    @IBOutlet weak var leftBetButton: UIButton!
    @IBOutlet weak var rightBetButton: UIButton!
    @IBOutlet weak var drawBetButton: UIButton!

    @IBOutlet weak var gradientView: UIView?
    @IBOutlet weak var betView: UIView?

    var gradientLayer: CAGradientLayer?
    
    var delegate: DetailFeedCollectionReusableViewDelegate?
    
    private let imageLoader = ImageLoader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGradientView()
        setupButtons()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let gradientView = gradientView {
            gradientLayer?.frame = gradientView.bounds
        }
    }
    
    func setup(with event: Event) {
        
        if event.isLive {
            betView?.removeAllConstraints()
            betView?.isHidden = true
        }
        
        if let image = event.firstTeam.imageUrl {
            imageLoader.loadImage(urlString: image) { [weak self] image in
                self?.leftImageView?.image = image
            }
        }
        
        
        
        if let image = event.secondTeam.imageUrl {
            imageLoader.loadImage(urlString: image) { [weak self] image in
                self?.rightImageView?.image = image
            }
        }
        
        leftNameLabel?.text = event.firstTeam.name
        rightNameLabel?.text = event.secondTeam.name
        
        leftValueLabel?.text = "\(event.betSum.firstBet)"
        rightValueLabel?.text = "\(event.betSum.secondBet)"
        
        progressView?.setup(left: CGFloat(event.betSum.firstBet),
                            middle: CGFloat(event.betSum.drawBet),
                            right: CGFloat(event.betSum.secondBet))
        
        leftBetButton.setTitle("Bet on " + event.firstTeam.name, for: .normal)
        rightBetButton.setTitle("Bet on " + event.secondTeam.name, for: .normal)
        
    }
    
    @IBAction func leftBetButtonDidTapped() {
        self.delegate?.leftBetButtonDidTapped()
    }
    
    @IBAction func rightBetButtonDidTapped() {
        self.delegate?.rightBetButtonDidTapped()
    }
    
    @IBAction func drawBetButtonDidTapped() {
        self.delegate?.drawBetButtonDidTapped()
    }
    
}

private extension DetailFeedCollectionReusableView {

    private func setupGradientView() {

        guard let gradientView = gradientView else {
            return
        }

        gradientView.clipsToBounds = true
        gradientView.layer.bounds = gradientView.bounds

        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [UIColor.black.withAlphaComponent(0).cgColor,
                                UIColor.black.cgColor]
        gradientLayer.frame = gradientView.bounds
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        self.gradientLayer = gradientLayer
    }

    func setupButtons() {
        leftBetButton.pmStyle()
        drawBetButton.pmStyle()
        rightBetButton.pmStyle()
    }
}
