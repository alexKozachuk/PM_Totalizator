//
//  Bet.swift
//  PMProject
//
//  Created by Ilya Senchukov on 26.03.2021.
//

import Foundation
import TotalizatorNetworkLayer

struct Bet {
    
    public let betID, teamConfrontation: String
    public let choice: PossibleResult
    public let eventStartime, betTime: String
    public let amount: Int
    public let status: String?

    init(bet: TotalizatorNetworkLayer.BetsPreviewForUser) {
        self.betID = bet.betID
        self.teamConfrontation = bet.teamConfrontation
        self.status = bet.status
        self.eventStartime = bet.eventStartime
        self.betTime = bet.betTime
        self.choice = bet.choice
        self.amount = bet.amount
    }
}
