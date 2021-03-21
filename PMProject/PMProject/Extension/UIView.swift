//
//  UIView.swift
//  PMProject
//
//  Created by Ilya Senchukov on 19.03.2021.
//

import UIKit



extension UIView {

    enum Side {
        case top
        case bottom
    }

    func addBorder(side: Side, color: UIColor = .gray) {
        let border = UIView()

        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]

        switch side {
            case .bottom:
                border.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 1)
            case .top:
                border.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        }

        addSubview(border)
    }
}
