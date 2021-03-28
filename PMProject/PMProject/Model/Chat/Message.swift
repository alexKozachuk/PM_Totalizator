//
//  Message.swift
//  PMProject
//
//  Created by Sasha on 24/03/2021.
//

import Foundation
import TotalizatorNetworkLayer

struct Message: Hashable {
    
    var name: String
    var id: String
    var userId: String
    var imageURL: String
    var date: Date
    var text: String
    
    init(userId: String, text: String, name: String) {
        self.name = name
        self.userId = userId
        self.text = text
        self.date = Date()
        self.id = UUID().uuidString
        self.imageURL = "https://avatars.dicebear.com/api/human/\(userId).png"
    }
    
    init(message: TotalizatorNetworkLayer.Message) {
        let url = "https://avatars.dicebear.com/api/human/\(message.accountID).png"
        self.name = message.username
        self.date = message.time.isoTime ?? Date()
        self.id = message.id
        self.userId = message.accountID
        self.imageURL = message.avatarLink ?? url
        self.text = message.text
    }
    
}
