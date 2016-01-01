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
    @IBInspectable var progressBorderWidth: CGFloat = 40.0
    @IBInspectable var backgroundCircleColor: UIColor = UIColor.blackColor()
    @IBInspectable var backgroundBorderWidth: CGFloat = 40.0
    
    var progress: CGFloat = 0.0 {
        didSet {
            animateProgress(from: oldValue, to: progress)
        }
    }
    
    private let progressCircleLayer: CAShapeLayer = CAShapeLayer()
    private let backCircleLayer: CAShapeLayer = CAShapeLayer()
    private var circleCenter: CGPoint = CGPointZero
    
    private var progressCircleRadius: CGFloat {
        return CGFloat((self.frame.size.width - progressBorderWidth/2.0)/2.0)
    }
    
    private var backgroundCircleRadius: CGFloat {
        return CGFloat((self.frame.size.width - backgroundBorderWidth/2.0)/2.0)
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
        progress = 0.8
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
            radius: backgroundCircleRadius,
            startAngle: CGFloat(0),
            endAngle: CGFloat(M_PI * 2),
            clockwise: true)
        backCircleLayer.path = path.CGPath
        backCircleLayer.strokeColor = backgroundCircleColor.CGColor
        backCircleLayer.fillColor = nil
        backCircleLayer.lineWidth = backgroundBorderWidth
        self.layer.addSublayer(backCircleLayer)
    }
    
    func drawProgressCircle() {
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(M_PI + M_PI_2)
        let path = UIBezierPath(
            arcCenter: circleCenter,
            radius: progressCircleRadius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        progressCircleLayer.path = path.CGPath
        progressCircleLayer.lineWidth = progressBorderWidth
        progressCircleLayer.lineCap = kCALineCapRound
        progressCircleLayer.strokeColor = progressCircleColor.CGColor
        progressCircleLayer.fillColor = nil
        progressCircleLayer.strokeStart = 0.0
        progressCircleLayer.strokeEnd = progress
        self.layer.addSublayer(progressCircleLayer)
    }
    
    func animateProgress(from from: CGFloat, to: CGFloat) {
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = NSTimeInterval(progress * 1.5)
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.progressCircleLayer.strokeEnd = progress
        self.progressCircleLayer.addAnimation(animation, forKey: "progress")
        CATransaction.commit()
    }
}
