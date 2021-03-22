//
//  UIButton.swift
//  PMProject
//
//  Created by Ilya Senchukov on 22.03.2021.
//

import UIKit

extension UIButton {

    func pmStyle() {
        layer.cornerRadius = 2

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
}
