//
//  Message.swift
//  PMProject
//
//  Created by Sasha on 24/03/2021.
//

import Foundation

struct Message {
    
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
    
}
