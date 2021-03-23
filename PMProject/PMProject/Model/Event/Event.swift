//
//  Event.swift
//  PMProject
//
//  Created by Sasha on 20/03/2021.
//

import UIKit
import TotalizatorNetworkLayer

struct Event: Identifiable {
    var id: String
    var firstTeam: Team
    var secondTeam: Team
    var betSum: BetSum
    var margin: Double
    var startTime: Date
    
    var isLive: Bool {
        return startTime < Date()
    }
    
    init(event: TotalizatorNetworkLayer.Event) {
        self.id = event.id
        self.margin = event.margin
        self.startTime = event.startTime.isoDate ?? Date()
        self.firstTeam = Team(team: event.participant1)
        self.secondTeam = Team(team: event.participant2)
        self.betSum = BetSum(firstBet: event.amountW1, secondBet: event.amountW2, drawBet: event.amountX)
    }
}


