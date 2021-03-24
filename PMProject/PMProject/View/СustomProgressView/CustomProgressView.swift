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
    private var left: CGFloat = 0
    private var middle: CGFloat = 0
    private var sum: CGFloat = 0
    
    private let leftLayer = CALayer()
    private let middleLayer =  CALayer()
    
    override func awakeFromNib() {
        backgroundColor = rightColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        leftLayer.backgroundColor = leftColor.cgColor
        middleLayer.backgroundColor = middleColor.cgColor
        layer.addSublayer(leftLayer)
        layer.addSublayer(middleLayer)
    }
    
    func setup(left: CGFloat, middle: CGFloat, right: CGFloat) {
        let sum = left + middle + right
        guard sum != self.sum else {
            return
        }
        guard sum != 0 else {
            setNeedsDisplay()
            return
        }
        self.left = left / sum
        self.middle = middle / sum
        self.sum = sum
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        if sum == 0 {
            let middleSize = CGSize(width: rect.width, height: rect.height)
            let middleRect = CGRect(origin: .zero, size: middleSize)
            middleLayer.frame = middleRect
            return
        }
       
        let leftSize = CGSize(width: rect.width * left, height: rect.height)
        let leftRect = CGRect(origin: .zero, size: leftSize)
        leftLayer.frame = leftRect
        
        
        let middleSize = CGSize(width: rect.width * middle, height: rect.height)
        let middlePoint = CGPoint(x: rect.width * left, y: 0)
        let middleRect = CGRect(origin: middlePoint, size: middleSize)
        middleLayer.frame = middleRect
        
        
    }
    
}
