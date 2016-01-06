//
//  TodayScoreCircleView.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/02.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayModel
import LTMorphingLabel

@IBDesignable class TodayScoreCircleView: UIView {
    
    @IBInspectable var progressCircleColor: UIColor = Today.type(Today.masterScores.maxElement()!).color() {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var progressBorderWidth: CGFloat = 20.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var score: Int = Today.masterScores[0] {
        didSet {
            let toStrokeColor = Today.type(score).color()
            if animated {
                animateProgressFromScore(oldValue, toScore: score, fromStrokeColor: progressCircleColor, toStrokeColor: toStrokeColor, completion: { [unowned self] in
                    self.progressCircleColor = toStrokeColor
                    })
            } else {
                progressCircleLayer.strokeEnd = CGFloat(score)/CGFloat(Today.maxScore)
                progressCircleLayer.strokeColor = toStrokeColor.CGColor
                backCircleLayer.strokeColor = CGColorCreateCopyWithAlpha(toStrokeColor.CGColor, backgroundOpacity)
                progressCircleColor = toStrokeColor
            }
        }
    }
    
    var animated: Bool = true
    var animationDuration = 0.2
    
    private let minDuration = 0.2
    private let backgroundOpacity: CGFloat = 0.15
    
    private let progressCircleLayer: CAShapeLayer = CAShapeLayer()
    private let backCircleLayer: CAShapeLayer = CAShapeLayer()
    private var circleCenter: CGPoint = CGPointZero
    private var radius: CGFloat {
        return CGFloat((self.frame.size.width - progressBorderWidth/2.0)/2.0)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.addSublayer(backCircleLayer)
        self.layer.addSublayer(progressCircleLayer)
    }
    
    override func prepareForInterfaceBuilder() {
        self.layer.addSublayer(backCircleLayer)
        self.layer.addSublayer(progressCircleLayer)
        drawBackCircle()
        drawProgressCircle()
    }
    
    override func drawRect(rect: CGRect) {
        drawBackCircle()
        drawProgressCircle()
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
        backCircleLayer.strokeColor = CGColorCreateCopyWithAlpha(progressCircleColor.CGColor, backgroundOpacity)
        backCircleLayer.fillColor = nil
        backCircleLayer.lineWidth = progressBorderWidth
        
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
        progressCircleLayer.strokeEnd = CGFloat(score)/CGFloat(Today.maxScore)
    }
    
    func animateProgressFromScore(fromScore: Int, toScore:Int, fromStrokeColor: UIColor, toStrokeColor: UIColor, completion: () -> ()) {
        let fromStrokeEnd = CGFloat(fromScore)/CGFloat(Today.maxScore)
        let toStrokeEnd = CGFloat(toScore)/CGFloat(Today.maxScore)
        
        CATransaction.begin()
        
        animationDuration = max(NSTimeInterval(abs(toStrokeEnd - fromStrokeEnd)), minDuration)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = fromStrokeEnd
        strokeEndAnimation.toValue = toStrokeEnd
        progressCircleLayer.strokeEnd = toStrokeEnd
        
        let strokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeColorAnimation.fromValue = fromStrokeColor.CGColor
        strokeColorAnimation.toValue = toStrokeColor.CGColor
        progressCircleLayer.strokeColor = toStrokeColor.CGColor
        
        let progressCircleAnimationGroup = CAAnimationGroup()
        progressCircleAnimationGroup.duration = animationDuration
        progressCircleAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        progressCircleAnimationGroup.animations = [strokeEndAnimation, strokeColorAnimation]
        progressCircleLayer.addAnimation(progressCircleAnimationGroup, forKey: "progressCircle")
        
        let backgroundStrokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
        backgroundStrokeColorAnimation.duration = animationDuration
        backgroundStrokeColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        backgroundStrokeColorAnimation.fromValue = CGColorCreateCopyWithAlpha(fromStrokeColor.CGColor, backgroundOpacity)
        backgroundStrokeColorAnimation.toValue = CGColorCreateCopyWithAlpha(toStrokeColor.CGColor, backgroundOpacity)
        backCircleLayer.strokeColor = CGColorCreateCopyWithAlpha(toStrokeColor.CGColor, backgroundOpacity)
        backCircleLayer.addAnimation(backgroundStrokeColorAnimation, forKey: "backgroundCircle")
        
        CATransaction.setCompletionBlock(completion)
        CATransaction.commit()
    }
    
}