//
//  BalanceProvider.swift
//  PMProject
//
//  Created by Ilya Senchukov on 22.03.2021.
//

import UIKit

class BalanceProvider {

    private var timer: DispatchSourceTimer?

    func startTimer() {
        guard timer == nil else {
            return
        }

        let queue = DispatchQueue(label: "com.pmtech.totalizator.timer", attributes: .concurrent)

        timer = DispatchSource.makeTimerSource(queue: queue)

        timer?.setEventHandler {
            print(Date())
        }

        timer?.schedule(deadline: .now(), repeating: .seconds(5))

        timer?.resume()
        print("started")
    }

    func stopTimer() {
        timer = nil
        print("stopped")
    }
}

private extension BalanceProvider {

}
