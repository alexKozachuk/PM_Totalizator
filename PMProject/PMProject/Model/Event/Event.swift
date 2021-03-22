//
//  Event.swift
//  PMProject
//
//  Created by Sasha on 20/03/2021.
//

import UIKit

struct Event: Identifiable {
    var id: Int
    var firstTeam: Team
    var secondTeam: Team
    var betSum: BetSum
    var marge: Double = 0.0
    var startTime: Date = Date()
    
    var isLive: Bool {
        return startTime < Date()
    }
}


