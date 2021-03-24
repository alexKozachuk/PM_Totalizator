//
//  Date+Extension.swift
//  PMProject
//
//  Created by Sasha on 24/03/2021.
//

import Foundation

extension Date {
    
    var timeString: String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let currentTime = formatter.string(from: self)
        
        return currentTime
    }
    
}
