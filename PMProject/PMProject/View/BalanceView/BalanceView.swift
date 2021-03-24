//
//  BalanceView.swift
//  PMProject
//
//  Created by Ilya Senchukov on 22.03.2021.
//

import UIKit

class BalanceView: UIBarButtonItem {

    var balance: Double

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
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.textAlignment = .right
        label.text = "UAH \n\(balance.rounded(places: 1)) "
        label.font = UIFont(name: "RobotoCondensed-Bold", size: 14)
        
        customView = label
    }
}
