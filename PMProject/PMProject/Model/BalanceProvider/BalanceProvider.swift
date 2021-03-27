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

    var timerLabel = "com.pmtech.totalizator.timer.BalanceProvider"
    var timeInterval: Int = 5
    
    weak var delegate: BalanceProviderDelegate?

    var timer: DispatchSourceTimer?

    var networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    var balance: Double = 0

}

private extension BalanceProvider {

    func fetchBalance(completion: @escaping (Double?) -> Void) {
        networkManager.wallet { result in
            
            switch result {
            case .failure:
                completion(nil)
            case .success(let wallet):
                completion(wallet.amount)
            }
            
        }
    }
}

extension BalanceProvider: EventUpdating {
    
    func eventHandler() {
        self.fetchBalance { [weak self] balance in
            guard let balance = balance else {
                return
            }

            self?.balance = balance
            self?.delegate?.update(balance: balance)
        }
    }
    
}
