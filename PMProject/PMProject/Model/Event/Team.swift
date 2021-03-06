//
//  Team.swift
//  PMProject
//
//  Created by Sasha on 20/03/2021.
//

import Foundation
import TotalizatorNetworkLayer

struct Team: Identifiable, Hashable {
    var id: String
    var name: String
    var imageUrl: String?
    var characteristics: [String: String] = [:]
    
    init(team: TotalizatorNetworkLayer.Participant) {
        self.id = team.id
        self.name = team.name
        self.imageUrl = team.photoLink
        
        team.parameters.forEach { param in
            self.characteristics[param.type] = param.value
        }
        
    }
    
}
