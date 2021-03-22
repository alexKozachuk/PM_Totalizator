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

extension UIView {
    
    public func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
}
