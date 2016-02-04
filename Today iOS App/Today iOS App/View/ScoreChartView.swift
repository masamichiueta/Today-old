//
//  ScoreChartView.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/31.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

class ScoreChartView: ChartViewBase {
    
    @IBOutlet weak var summaryStackView: UIStackView!
    @IBOutlet weak var ChartTitleLabel: UILabel!
    @IBOutlet weak var highScoreNumberLabel: UILabel!
    @IBOutlet weak var lowScoreNumberLabel: UILabel!
    
    @IBOutlet weak var summaryStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryStackViewLeadingConstraint: NSLayoutConstraint!
    
    var gradient: CGGradientRef = {
        
        let colors: [CGColor] = [
            UIColor.todayGradientRedStartColor().CGColor,
            UIColor.todayGradientRedEndColor().CGColor
        ]
        let locations: [CGFloat] = [0.0, 1.0]
        return CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), colors, locations)!
    }()

    override func drawRect(rect: CGRect) {
        let clipPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10.0)
        clipPath.addClip()
        
        drawBackgroundGradient()
        
        let xLabelHeight: CGFloat = 40.0
        let borderRect = CGRect(
            origin: CGPoint(
                x: summaryStackViewLeadingConstraint.constant,
                y: CGRectGetMaxY(summaryStackView.frame) + summaryStackViewTopConstraint.constant
            ),
            size: CGSize(
                width: CGRectGetWidth(self.frame) - summaryStackViewLeadingConstraint.constant * 2,
                height: CGRectGetHeight(self.frame) - CGRectGetHeight(summaryStackView.frame) - summaryStackViewTopConstraint.constant - xLabelHeight
            )
        )
        
        drawHorizontalLineInRect(borderRect)
        
        let chartHorizontalMargin: CGFloat = 16.0
        let datelabelRect = CGRect(
            origin: CGPoint(
                x: CGRectGetMinX(borderRect) + chartHorizontalMargin,
                y: CGRectGetMaxY(borderRect)),
            size: CGSize(
                width: CGRectGetWidth(borderRect) - chartHorizontalMargin * 2,
                height: xLabelHeight))
        
        drawXLabelInRect(datelabelRect)
        
        
        
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
    }
    
    private func drawBackgroundGradient() {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        let startPoint = CGPoint(x: CGRectGetMidX(self.bounds), y: 0)
        let endPoint = CGPoint(x: CGRectGetMidX(self.bounds), y: CGRectGetMaxY(self.bounds))
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, [])
        CGContextRestoreGState(ctx)
    }
    
    private func drawHorizontalLineInRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        UIColor.whiteColor().setStroke()
        let horizontalLine = UIBezierPath()
        horizontalLine.lineWidth = 1.0
        horizontalLine.moveToPoint(CGPoint(x: rint(CGRectGetMinX(rect)), y: CGRectGetMinY(rect)))
        horizontalLine.addLineToPoint(CGPoint(x: rint(CGRectGetMaxX(rect)), y: CGRectGetMinY(rect)))
        CGContextSaveGState(ctx)
        horizontalLine.stroke()
        CGContextTranslateCTM(ctx, 0.0, CGRectGetHeight(rect))
        horizontalLine.stroke()
        CGContextRestoreGState(ctx)
        CGContextRestoreGState(ctx)
    }
    
    private func drawXLabelInRect(rect: CGRect) {
        guard let dataSource = dataSource else {
            return
        }
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        let font = UIFont.systemFontOfSize(12.0)
        let labelSpace = (CGRectGetWidth(rect) / CGFloat(dataSource.numberOfObjects() - 1))
        CGContextTranslateCTM(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect))
        
        for i in 0..<dataSource.numberOfObjects() {
            guard let label = dataSource.chartView(self, xLabelForAtXIndex: i) else {
                continue
            }
            let labelSize = label.sizeWithAttributes([NSFontAttributeName: font])
            label.drawInRect(CGRect(x: labelSpace * CGFloat(i) - labelSize.width / 2.0, y: 0.0, width: labelSize.width, height: labelSize.height), withAttributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        CGContextRestoreGState(ctx)
    }
}
