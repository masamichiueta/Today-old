//
//  CircleView.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/28.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit


@IBDesignable class CircleView: UIView {

    @IBInspectable var progressCircleColor: UIColor = UIColor.clearColor()
    @IBInspectable var backCircleColor: UIColor = UIColor.blackColor()
    @IBInspectable var layerOpacity: Double = 0.1
    @IBInspectable var borderWidth: Double = 20.0
    
    private let progressCircleLayer: CAShapeLayer = CAShapeLayer()
    private let backCircleLayer: CAShapeLayer = CAShapeLayer()
    private var circleCenter: CGPoint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circleCenter = CGPoint(
            x: (self.frame.origin.x + self.frame.size.width/2.0),
            y: (self.frame.origin.y + self.frame.size.height/2.0))
    }
    
    override func prepareForInterfaceBuilder() {
        drawBackCircle()
    }
    

    override func drawRect(rect: CGRect) {
        drawBackCircle()
    }
    
    
    func drawBackCircle() {
        let path = UIBezierPath(
            arcCenter: circleCenter,
            radius: CGFloat(self.frame.size.width/2.0),
            startAngle: CGFloat(0),
            endAngle: CGFloat(M_PI * 2),
            clockwise: true)
        backCircleLayer.path = path.CGPath
        backCircleLayer.strokeColor = backCircleColor.CGColor
        backCircleLayer.opacity = Float(layerOpacity)
        backCircleLayer.fillColor = nil
        backCircleLayer.lineWidth = CGFloat(borderWidth)
        self.layer.addSublayer(backCircleLayer)
    }
}
