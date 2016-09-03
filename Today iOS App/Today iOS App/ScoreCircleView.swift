//
//  ScoreCircleView.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/02.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

@IBDesignable class ScoreCircleView: UIView {
    
    @IBInspectable var progressCircleColor: UIColor = Today.type(Today.masterScores.max()!).color() {
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
                progressCircleLayer.strokeEnd = CGFloat(score)/CGFloat(Today.maxMasterScore)
                progressCircleLayer.strokeColor = toStrokeColor.cgColor.copy(alpha: backgroundOpacity)
                progressCircleColor = toStrokeColor
            }
        }
    }
    
    var animated: Bool = true
    var animationDuration = 0.2
    
    fileprivate let minDuration = 0.2
    fileprivate let backgroundOpacity: CGFloat = 0.15
    
    fileprivate let progressCircleLayer: CAShapeLayer = CAShapeLayer()
    fileprivate let backCircleLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var circleCenter: CGPoint = CGPoint(x: 0, y: 0)
    fileprivate var radius: CGFloat {
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
    
    override func draw(_ rect: CGRect) {
        drawBackCircle()
        drawProgressCircle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleCenter = CGPoint(
            x: self.frame.size.width/2.0,
            y: self.frame.size.height/2.0 )
    }
    
    fileprivate func drawBackCircle() {
        let path = UIBezierPath(
            arcCenter: circleCenter,
            radius: radius,
            startAngle: CGFloat(0),
            endAngle: CGFloat(M_PI * 2),
            clockwise: true)
        backCircleLayer.path = path.cgPath
        backCircleLayer.strokeColor = progressCircleColor.cgColor.copy(alpha: backgroundOpacity)
        backCircleLayer.fillColor = nil
        backCircleLayer.lineWidth = progressBorderWidth
        
    }
    
    fileprivate func drawProgressCircle() {
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(M_PI + M_PI_2)
        let path = UIBezierPath(
            arcCenter: circleCenter,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        progressCircleLayer.path = path.cgPath
        progressCircleLayer.lineWidth = progressBorderWidth
        progressCircleLayer.lineCap = kCALineCapRound
        progressCircleLayer.strokeColor = progressCircleColor.cgColor
        progressCircleLayer.fillColor = nil
        progressCircleLayer.strokeStart = 0.0
        progressCircleLayer.strokeEnd = CGFloat(score)/CGFloat(Today.maxMasterScore)
    }
    
    fileprivate func animateProgressFromScore(_ fromScore: Int, toScore: Int, fromStrokeColor: UIColor, toStrokeColor: UIColor, completion: (() -> Void)?) {
        let fromStrokeEnd = CGFloat(fromScore)/CGFloat(Today.maxMasterScore)
        let toStrokeEnd = CGFloat(toScore)/CGFloat(Today.maxMasterScore)
        
        CATransaction.begin()
        
        animationDuration = max(TimeInterval(abs(toStrokeEnd - fromStrokeEnd)), minDuration)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = fromStrokeEnd
        strokeEndAnimation.toValue = toStrokeEnd
        progressCircleLayer.strokeEnd = toStrokeEnd
        
        let strokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeColorAnimation.fromValue = fromStrokeColor.cgColor
        strokeColorAnimation.toValue = toStrokeColor.cgColor
        progressCircleLayer.strokeColor = toStrokeColor.cgColor
        
        let progressCircleAnimationGroup = CAAnimationGroup()
        progressCircleAnimationGroup.duration = animationDuration
        progressCircleAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        progressCircleAnimationGroup.animations = [strokeEndAnimation, strokeColorAnimation]
        progressCircleLayer.add(progressCircleAnimationGroup, forKey: "progressCircle")
        
        let backgroundStrokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
        backgroundStrokeColorAnimation.duration = animationDuration
        backgroundStrokeColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        backgroundStrokeColorAnimation.fromValue = fromStrokeColor.cgColor.copy(alpha: backgroundOpacity)
        backgroundStrokeColorAnimation.toValue = toStrokeColor.cgColor.copy(alpha: backgroundOpacity)
        backCircleLayer.strokeColor = toStrokeColor.cgColor.copy(alpha: backgroundOpacity)
        backCircleLayer.add(backgroundStrokeColorAnimation, forKey: "backgroundCircle")
                
        CATransaction.setCompletionBlock(completion)
        CATransaction.commit()
    }
}
