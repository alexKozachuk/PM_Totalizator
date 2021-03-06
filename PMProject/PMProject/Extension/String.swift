//
//  String+Extension.swift
//  PMProject
//
//  Created by Sasha on 23/03/2021.
//

import Foundation

extension String {
    
    var isoDate: Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self)
        
        return date
    }
    
    var isoTime: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: self)
        
        return date
    }
    
}


