//
//  BetHistoryCollectionViewCell.swift
//  PMProject
//
//  Created by Ilya Senchukov on 26.03.2021.
//

import UIKit
import TotalizatorNetworkLayer

class BetHistoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var eventNameLabel: UILabel?
    @IBOutlet weak var choiceLabel: UILabel?
    @IBOutlet weak var betAmountLabel: UILabel?

    var amount: Double? {
        didSet {
            guard let amount = amount else { return }

            betAmountLabel?.text = "\(amount.rounded(places: 1)) UAH"
        }
    }

    var choice: PossibleResult? {
        didSet {
            switch choice {
                case .w1:
                    choiceLabel?.text = "1"
                case .w2:
                    choiceLabel?.text = "2"
                case .x:
                    choiceLabel?.text = "X"
                default:
                    choiceLabel?.text = choice?.rawValue
            }
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
        choice = bet.choice
    }
}
