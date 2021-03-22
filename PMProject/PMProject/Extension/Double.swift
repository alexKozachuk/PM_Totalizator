//
//  Double.swift
//  PMProject
//
//  Created by Ilya Senchukov on 22.03.2021.
//

import Foundation

extension Double {

    func rounded(places :Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
