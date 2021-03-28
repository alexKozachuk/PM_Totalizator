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
    @IBOutlet weak var betStatusLabel: UILabel?
    @IBOutlet weak var dateBetLabel: UILabel?
    @IBOutlet weak var dateEventLabel: UILabel?

    var amount: Double? {
        get {
            return Double(betAmountLabel?.text ?? "0")
        }
        set {
            guard let amount = newValue else { return }

            betAmountLabel?.text = "\(amount.rounded(places: 1)) UAH"
        }
    }

    var choice: PossibleResult? {
        get {
            return PossibleResult(rawValue: choiceLabel?.text ?? "X")
        }
        set {
            switch newValue {
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
        get {
            return eventNameLabel?.text
        }
        set {
            eventNameLabel?.text = newValue
        }
    }

    var status: String? {
        get {
            return betStatusLabel?.text
        }
        set {
            betStatusLabel?.text = newValue
        }
    }

    var dateEvent: String? {
        get {
            return dateEventLabel?.text
        }
        set {
            dateEventLabel?.text = newValue
        }
    }
    
    var dateBet: String? {
        get {
            return dateBetLabel?.text
        }
        set {
            dateBetLabel?.text = newValue
        }
    }

    func setup(bet: Bet) {
        let dateEvent = bet.betTime.isoTime ?? bet.betTime.isoDate ?? Date()
        let dateBet = bet.eventStartime.isoTime ?? bet.eventStartime.isoDate ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM, HH:mm"
        
        amount = Double(bet.amount)
        choice = bet.choice
        eventName = bet.teamConfrontation
        status = bet.status
        self.dateBet = formatter.string(from: dateBet)
        self.dateEvent = formatter.string(from: dateEvent)
    }
}
