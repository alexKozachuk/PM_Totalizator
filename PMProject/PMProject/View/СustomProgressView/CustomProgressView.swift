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
    
    private let leftLayer = CALayer()
    private let middleLayer =  CALayer()
    
    override func awakeFromNib() {
        backgroundColor = rightColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(leftLayer)
        layer.addSublayer(middleLayer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.addSublayer(leftLayer)
        layer.addSublayer(middleLayer)
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
        leftLayer.frame = leftRect
        leftLayer.backgroundColor = leftColor.cgColor
        
        let middleSize = CGSize(width: rect.width * middle, height: rect.height)
        let middlePoint = CGPoint(x: rect.width * left, y: 0)
        let middleRect = CGRect(origin: middlePoint, size: middleSize)
        middleLayer.frame = middleRect
        middleLayer.backgroundColor = middleColor.cgColor
        
    }
    
}
