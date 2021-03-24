//
//  BalanceProvider.swift
//  PMProject
//
//  Created by Ilya Senchukov on 22.03.2021.
//

import UIKit
import TotalizatorNetworkLayer

protocol BalanceProviderDelegate: AnyObject {
    func update(balance: Double)
}

class BalanceProvider {

    weak var delegate: BalanceProviderDelegate?

    private var timer: DispatchSourceTimer?

    var networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    var balance: Double = 0

    func startTimer() {
        guard timer == nil else {
            return
        }

        let queue = DispatchQueue(label: "com.pmtech.totalizator.timer", attributes: .concurrent)

        timer = DispatchSource.makeTimerSource(queue: queue)

        timer?.setEventHandler { [weak self] in
            self?.fetchBalance { [weak self] balance in
                guard let balance = balance else {
                    print("Error fetching balance")
                    return
                }

                self?.balance = balance
                self?.delegate?.update(balance: balance)
            }

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

    func fetchBalance(completion: @escaping (Double?) -> Void) {
        networkManager.wallet { result in
            
            switch result {
            case .failure(let error):
                print(error)
                completion(nil)
            case .success(let wallet):
                completion(wallet.amount)
            }
            
        }
    }
}
