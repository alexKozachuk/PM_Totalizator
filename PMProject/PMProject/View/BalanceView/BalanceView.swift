//
//  BalanceView.swift
//  PMProject
//
//  Created by Ilya Senchukov on 22.03.2021.
//

import UIKit

class BalanceView: UIBarButtonItem {

    var balance: Double
    weak var coordinator: MainCoordinator?

    init(balance: Double) {
        self.balance = balance
        super.init()

        commonInit()
    }

    required init?(coder: NSCoder) {
        self.balance = 0
        super.init(coder: coder)

        commonInit()
    }
}

private extension BalanceView {

    func commonInit() {
        let button = UIButton(frame: .zero)
        button.setTitle("UAH \n\(balance.rounded(places: 1)) ", for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont(name: "RobotoCondensed-Bold", size: 14)
        
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        
        customView = button
    }
    
    @objc func buttonDidTapped() {
        coordinator?.presentDepositPage()
    }
}
