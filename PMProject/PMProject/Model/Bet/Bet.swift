//
//  Bet.swift
//  PMProject
//
//  Created by Ilya Senchukov on 26.03.2021.
//

import Foundation
import TotalizatorNetworkLayer

struct Bet {

    public let accountID, eventID: String
    public let choice: PossibleResult
    public let amount: Int

    init(accountID: String, eventID: String, choice: PossibleResult, amount: Int) {
        self.accountID = accountID
        self.eventID = eventID
        self.choice = choice
        self.amount = amount
    }

    init(bet: TotalizatorNetworkLayer.Bet) {
        self.accountID = bet.accountID
        self.eventID = bet.eventID
        self.choice = bet.choice
        self.amount = bet.amount
    }
}
