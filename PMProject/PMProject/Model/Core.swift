//
//  Core.swift
//  PMProject
//
//  Created by Dmytro Yurchenko on 29.03.2021.
//

import Foundation

final class Core {
    static let shared = Core()
    
    func openingAppFirstTime() -> Bool {
        return !UserDefaults.standard.bool(forKey: "firstTime")
    }
    
    func setAlreadyOpened() {
        UserDefaults.standard.set(true, forKey: "firstTime")
    }
}
