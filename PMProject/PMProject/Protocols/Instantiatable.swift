//
//  Instantiatable.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import UIKit

protocol Instantiatable: UIViewController {

}

extension Instantiatable {
    init() {
        self.init(nibName: String(describing: Self.self), bundle: nil)
    }
}
