//
//  ProgressCircleView.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/02.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayModel

@IBDesignable class ProgressCircleView: UIView {
    
    @IBInspectable var progressCircleColor: UIColor = Today.todayType(0).color() {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var progressBorderWidth: CGFloat = 40.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var progress: CGFloat = 0.0 {
        didSet {
            let color = Today.todayType(Int(progress*10)).color()
            let prop = AnimationProperty(strokeFrom: oldValue, strokeTo: progress, colorFrom: progressCircleColor, colorTo: color)
            animateProgress(prop, completion: { [unowned self] in
                self.progressCircleColor = color
            })
        }
    }
    
    private let progressCircleLayer: CAShapeLayer = CAShapeLayer()
    private let backCircleLayer: CAShapeLayer = CAShapeLayer()
    private var circleCenter: CGPoint = CGPointZero
    
    private var radius: CGFloat {
        return CGFloat((self.frame.size.width - progressBorderWidth/2.0)/2.0)
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
        
        print("draw rect")
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
        backCircleLayer.strokeColor = CGColorCreateCopyWithAlpha(progressCircleColor.CGColor, 0.15)
        backCircleLayer.fillColor = nil
        backCircleLayer.lineWidth = progressBorderWidth
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
        progressCircleLayer.lineWidth = progressBorderWidth
        progressCircleLayer.lineCap = kCALineCapRound
        progressCircleLayer.strokeColor = progressCircleColor.CGColor
        progressCircleLayer.fillColor = nil
        progressCircleLayer.strokeStart = 0.0
        progressCircleLayer.strokeEnd = progress
        self.layer.addSublayer(progressCircleLayer)
    }
    
    struct AnimationProperty {
        var strokeFrom: CGFloat
        var strokeTo: CGFloat
        var colorFrom: UIColor
        var colorTo: UIColor
    }
    
    func animateProgress(prop: AnimationProperty, completion: () -> ()) {
        CATransaction.begin()
        
        let duration = NSTimeInterval(abs(prop.strokeTo - prop.strokeFrom))
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = prop.strokeFrom
        strokeEndAnimation.toValue = prop.strokeTo
        self.progressCircleLayer.strokeEnd = prop.strokeTo
        
        let strokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeColorAnimation.fromValue = prop.colorFrom.CGColor
        strokeColorAnimation.toValue = prop.colorTo.CGColor
        self.progressCircleLayer.strokeColor = prop.colorTo.CGColor
        
        let progressCircleAnimationGroup = CAAnimationGroup()
        progressCircleAnimationGroup.duration = duration
        progressCircleAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        progressCircleAnimationGroup.animations = [strokeEndAnimation, strokeColorAnimation]
        self.progressCircleLayer.addAnimation(progressCircleAnimationGroup, forKey: "progressCircle")
        
        let backgroundStrokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
        backgroundStrokeColorAnimation.duration = duration
        backgroundStrokeColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        backgroundStrokeColorAnimation.fromValue = CGColorCreateCopyWithAlpha(prop.colorFrom.CGColor, 0.15)
        backgroundStrokeColorAnimation.toValue = CGColorCreateCopyWithAlpha(prop.colorTo.CGColor, 0.15)
        self.backCircleLayer.strokeColor = CGColorCreateCopyWithAlpha(prop.colorTo.CGColor, 0.15)
        self.backCircleLayer.addAnimation(backgroundStrokeColorAnimation, forKey: "backgroundCircle")
        
        CATransaction.setCompletionBlock(completion)
        CATransaction.commit()
    }
    
}