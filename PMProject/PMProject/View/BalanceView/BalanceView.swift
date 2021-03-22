//
//  BalanceView.swift
//  PMProject
//
//  Created by Ilya Senchukov on 22.03.2021.
//

import UIKit

class BalanceView: UIBarButtonItem {

    override init() {
        super.init()

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }
}

private extension BalanceView {

    func commonInit() {
        let label = UILabel(frame: .zero)
        label.text = "100 uah"
        label.font = UIFont(name: "RobotoCondensed-Regular", size: 15)
        
        customView = label
    }
}
