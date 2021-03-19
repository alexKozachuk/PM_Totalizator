//
//  CustomProgressView.swift
//  PMProject
//
//  Created by Sasha on 19/03/2021.
//

import UIKit

class CustomProgressView: UIView {

    @IBInspectable var leftColor: UIColor = .yellow
    @IBInspectable var middleColor: UIColor = .white
    @IBInspectable var rightColor: UIColor = .red
    private var left: CGFloat = 1 / 3
    private var middle: CGFloat = 1 / 3
    
    override func awakeFromNib() {
        backgroundColor = rightColor
    }
    
    func setup(left: CGFloat, middle: CGFloat, right: CGFloat) {
        let sum = left + middle + right
        self.left = left / sum
        self.middle = middle / sum
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
       
        let leftSize = CGSize(width: rect.width * left, height: rect.height)
        let leftRect = CGRect(origin: .zero, size: leftSize)
        let leftLayer = CALayer()
        leftLayer.frame = leftRect
        layer.addSublayer(leftLayer)
        leftLayer.backgroundColor = leftColor.cgColor
        
        let middleSize = CGSize(width: rect.width * middle, height: rect.height)
        let middlePoint = CGPoint(x: rect.width * left, y: 0)
        let middleRect = CGRect(origin: middlePoint, size: middleSize)
        let middleLayer = CALayer()
        middleLayer.frame = middleRect
        layer.addSublayer(middleLayer)
        middleLayer.backgroundColor = middleColor.cgColor
        
    }
    
}
