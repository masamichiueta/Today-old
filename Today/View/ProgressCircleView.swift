//
//  ProgressCircleView.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/28.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit


@IBDesignable class ProgressCircleView: UIView {

    @IBInspectable var progressCircleColor: UIColor = UIColor.clearColor()
    @IBInspectable var backCircleColor: UIColor = UIColor.blackColor()
    @IBInspectable var layerOpacity: Float = 0.1
    @IBInspectable var borderWidth: CGFloat = 40.0
    
    var currentProgress: CGFloat = 0.0
    var progress: CGFloat = 0.0
    
    private let progressCircleLayer: CAShapeLayer = CAShapeLayer()
    private let backCircleLayer: CAShapeLayer = CAShapeLayer()
    private var circleCenter: CGPoint = CGPointZero
    private var radius: CGFloat {
        return CGFloat((self.frame.size.width - borderWidth/2.0)/2.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForInterfaceBuilder() {
        drawBackCircle()
        drawProgressCircle()
    }

    override func drawRect(rect: CGRect) {
        drawBackCircle()
        drawProgressCircle()
        animate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleCenter = CGPoint(
            x: self.frame.size.width/2.0,
            y: self.frame.size.height/2.0 )
    }
    
    
    func drawBackCircle() {
        let path = UIBezierPath(
            arcCenter: circleCenter,
            radius: radius,
            startAngle: CGFloat(0),
            endAngle: CGFloat(M_PI * 2),
            clockwise: true)
        backCircleLayer.path = path.CGPath
        backCircleLayer.strokeColor = backCircleColor.CGColor
        backCircleLayer.opacity = layerOpacity
        backCircleLayer.fillColor = nil
        backCircleLayer.lineWidth = borderWidth
        self.layer.addSublayer(backCircleLayer)
    }
    
    func drawProgressCircle() {
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(M_PI + M_PI_2)
        let path = UIBezierPath(
            arcCenter: circleCenter,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        progressCircleLayer.path = path.CGPath
        progressCircleLayer.lineWidth = borderWidth
        progressCircleLayer.lineCap = kCALineCapRound
        progressCircleLayer.strokeColor = progressCircleColor.CGColor
        progressCircleLayer.fillColor = nil
        progressCircleLayer.strokeStart = 0.0
        progressCircleLayer.strokeEnd = currentProgress
        self.layer.addSublayer(progressCircleLayer)
    }
    
    func animate() {
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = currentProgress
        animation.toValue = progress
        animation.duration = NSTimeInterval(progress * 1.5)
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.progressCircleLayer.strokeEnd = progress
        CATransaction.setCompletionBlock { [unowned self] in
            self.currentProgress = self.progress
        }
        self.progressCircleLayer.addAnimation(animation, forKey: "Progress")
        CATransaction.commit()
    }
}
