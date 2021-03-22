//
//  BalanceView.swift
//  PMProject
//
//  Created by Ilya Senchukov on 22.03.2021.
//

import UIKit

class BalanceView: UIBarButtonItem {

    var balance: Int

    init(balance: Int) {
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
        label.text = "\(balance) uah"
        label.font = UIFont(name: "RobotoCondensed-Regular", size: 15)
        
        customView = label
    }
}
