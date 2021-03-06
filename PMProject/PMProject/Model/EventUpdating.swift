//
//  EventUpdater.swift
//  PMProject
//
//  Created by Sasha on 26/03/2021.
//

import Foundation


protocol EventUpdating: class {
    
    var timerLabel: String { get set }
    var timer: DispatchSourceTimer? { get set }
    func eventHandler()
    func startUpdating()
    func stopUpdating()
    var timeInterval: Int { get set }
    
}

extension EventUpdating {
    
    func startUpdating() {
        let queue = DispatchQueue(label: timerLabel, attributes: .concurrent)
        self.timer = DispatchSource.makeTimerSource(queue: queue)
        
        timer?.setEventHandler { [weak self] in
            self?.eventHandler()
        }
        
        timer?.schedule(deadline: .now(), repeating: .seconds(timeInterval))
        
        timer?.resume()
    }
    
    func stopUpdating() {
        timer = nil
    }
    
    
}
