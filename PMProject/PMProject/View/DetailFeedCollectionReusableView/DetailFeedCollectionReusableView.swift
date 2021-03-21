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
    
    var delegate: DetailFeedCollectionReusableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup() {
        progressView?.setup(left: 170, middle: 20, right: 280)
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
