//
//  UIResponder.swift
//  PMProject
//
//  Created by Ilya Senchukov on 19.03.2021.
//

import UIKit

extension UIResponder {

    class var reuseIdentifier: String {
        String(describing: self)
    }

}
