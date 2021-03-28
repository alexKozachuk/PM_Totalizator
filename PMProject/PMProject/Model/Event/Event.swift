//
//  Event.swift
//  PMProject
//
//  Created by Sasha on 20/03/2021.
//

import UIKit
import TotalizatorNetworkLayer

struct Event: Identifiable, Hashable {
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
        self.startTime = event.startTime.isoDate ?? event.startTime.isoTime ?? Date()
        self.firstTeam = Team(team: event.participant1)
        self.secondTeam = Team(team: event.participant2)
        self.betSum = BetSum(firstBet: event.amountW1, secondBet: event.amountW2, drawBet: event.amountX)
    }
    
    func potentialGain(result: PossibleResult, bet: Double) -> Double {
        
        let margePersent = 1 - (margin / 100)
        var winPul: Double = 0
        var loosePul: Double = 0
        
        switch result {
        case .w1:
            winPul = Double(betSum.firstBet)
            loosePul = Double(betSum.drawBet + betSum.secondBet)
            break
        case .w2:
            winPul = Double(betSum.secondBet)
            loosePul = Double(betSum.drawBet + betSum.firstBet)
            break
        case .x:
            winPul = Double(betSum.drawBet)
            loosePul = Double(betSum.firstBet + betSum.secondBet)
            break
        }
        
        winPul = winPul * margePersent
        loosePul = loosePul * margePersent
        let betWithMarhin = bet * margePersent
        
        let share = betWithMarhin / (winPul + betWithMarhin)
        let sum = (loosePul * share) + betWithMarhin
        
        return sum
    }
        
}


