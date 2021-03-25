//
//  BetHistoryCollectionViewCell.swift
//  PMProject
//
//  Created by Ilya Senchukov on 26.03.2021.
//

import UIKit

class BetHistoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var eventNameLabel: UILabel?
    @IBOutlet weak var betAmountLabel: UILabel?

    var amount: Double? {
        didSet {
            guard let amount = amount else { return }

            betAmountLabel?.text = "\(amount.rounded(places: 1)) UAH"
        }
    }

    var eventName: String? {
        didSet {
            eventNameLabel?.text = eventName
        }
    }

    func setup(bet: Bet) {
        amount = Double(bet.amount)
        eventName = bet.eventID
    }
}
