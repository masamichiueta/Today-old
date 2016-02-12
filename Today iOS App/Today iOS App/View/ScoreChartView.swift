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
    @IBOutlet weak var chartTitleLabel: UILabel!
    @IBOutlet weak var highScoreNumberLabel: UILabel!
    @IBOutlet weak var lowScoreNumberLabel: UILabel!
    @IBOutlet weak var summaryStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryStackViewLeadingConstraint: NSLayoutConstraint!
    
    var customMaxYValue: Int?
    var customMinYValue: Int?
    var axisFont = UIFont.systemFontOfSize(12.0)
    
    var gradient: CGGradientRef = {
        
        let colors: [CGColor] = [
            UIColor.todayGradientRedStartColor().CGColor,
            UIColor.todayGradientRedEndColor().CGColor
        ]
        let locations: [CGFloat] = [0.0, 1.0]
        return CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), colors, locations)!
    }()
    
    
    
    override func drawRect(rect: CGRect) {
        let clipPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10.0)
        clipPath.addClip()
        
        drawBackgroundGradient()
        
        let xValueHeight: CGFloat = 40.0
        let yValueWidth: CGFloat = 20.0
        let chartHorizontalMargin: CGFloat = 16.0
        let chartVerticalMargin: CGFloat = 16.0
        
        let borderRect = CGRect(
            origin: CGPoint(
                x: summaryStackViewLeadingConstraint.constant,
                y: summaryStackView.frame.maxY + summaryStackViewTopConstraint.constant
            ),
            size: CGSize(
                width: frame.width - summaryStackViewLeadingConstraint.constant * 2,
                height: frame.height - summaryStackView.frame.height - summaryStackViewTopConstraint.constant - xValueHeight))
        drawHorizontalLineInRect(borderRect)
        
        let xLabelRect = CGRect(
            origin: CGPoint(
                x: borderRect.minX + chartHorizontalMargin,
                y: borderRect.maxY),
            size: CGSize(
                width: borderRect.width - yValueWidth - chartHorizontalMargin * 2,
                height: xValueHeight))
        drawXLabelInRect(xLabelRect)
        
        let yLabelRect = CGRect(
            origin: CGPoint(
                x: borderRect.maxX - yValueWidth,
                y: borderRect.minY + chartVerticalMargin),
            size: CGSize(
                width: yValueWidth,
                height: borderRect.height - chartVerticalMargin * 2))
        drawYLabelInRect(yLabelRect)
        
        let dataRect = CGRect(
            origin: CGPoint(
                x: borderRect.minX + chartHorizontalMargin,
                y: borderRect.minY + chartVerticalMargin),
            size: CGSize(
                width: xLabelRect.width,
                height: yLabelRect.height))
        
        drawDataInRect(dataRect)
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
    }
    
    //MARK: - Draiwng
    private func drawBackgroundGradient() {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        let startPoint = CGPoint(x: bounds.midX, y: 0)
        let endPoint = CGPoint(x: bounds.midX, y: bounds.maxX)
        if let latestYValue = dataSource?.latestYValue {
            gradient = Today.type(latestYValue).gradientColor()
        } else {
            gradient = TodayType.Poor.gradientColor()
        }
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, [])
        CGContextRestoreGState(ctx)
    }
    
    private func drawHorizontalLineInRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        UIColor.whiteColor().setStroke()
        let horizontalLine = UIBezierPath()
        horizontalLine.lineWidth = 0.5
        horizontalLine.moveToPoint(CGPoint(x: rect.minX, y: rect.minY))
        horizontalLine.addLineToPoint(CGPoint(x: rect.maxX, y: rect.minY))
        CGContextSaveGState(ctx)
        horizontalLine.stroke()
        CGContextTranslateCTM(ctx, 0.0, rect.height)
        horizontalLine.stroke()
        CGContextRestoreGState(ctx)
        CGContextRestoreGState(ctx)
    }
    
    private func drawXLabelInRect(rect: CGRect) {
        guard let dataSource = dataSource else {
            fatalError("No data source")
        }
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        let labelSpace = (rect.width / CGFloat(dataSource.numberOfObjects() - 1))
        CGContextTranslateCTM(ctx, rect.minX, rect.minY)
        
        for i in 0..<dataSource.numberOfObjects() {
            guard let data = dataSource.chartView(self, dataAtIndex: i),
                let label = data.xValue else {
                    continue
            }
            let labelSize = label.sizeWithAttributes([NSFontAttributeName: axisFont])
            label.drawInRect(CGRect(x: labelSpace * CGFloat(i) - labelSize.width / 2.0, y: 0.0, width: labelSize.width, height: labelSize.height), withAttributes: [NSFontAttributeName: axisFont, NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        CGContextRestoreGState(ctx)
    }
    
    private func drawYLabelInRect(rect: CGRect) {
        guard let dataSource = dataSource else {
            fatalError("No data source")
        }
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        CGContextTranslateCTM(ctx, rect.minX, rect.minY)
        
        guard let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as? NSMutableParagraphStyle else {
            fatalError("Wrong paragraph style")
        }
        paragraphStyle.alignment = .Right
        
        let maxYLabel: String
        if let customMaxYValue = customMaxYValue {
            maxYLabel = "\(customMaxYValue)"
        } else if let maxYValue = dataSource.maxYValue {
            maxYLabel = "\(maxYValue)"
        } else {
            maxYLabel = ""
        }
        
        let maxYLabelSize = maxYLabel.sizeWithAttributes([NSFontAttributeName: axisFont])
        maxYLabel.drawInRect(CGRect(x: 0.0, y: -(maxYLabelSize.height / 2.0), width: rect.width, height: maxYLabelSize.height), withAttributes: [NSFontAttributeName: axisFont, NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: paragraphStyle])
        
        let minYLabel: String
        if let customMinYValue = customMinYValue {
            minYLabel = "\(customMinYValue)"
        } else if let minYValue = dataSource.minYValue {
            minYLabel = "\(minYValue)"
        } else {
            minYLabel = ""
        }
        
        let minYLabelSize = minYLabel.sizeWithAttributes([NSFontAttributeName: axisFont])
        minYLabel.drawInRect(CGRect(x: 0.0, y: rect.height - minYLabelSize.height / 2.0, width: rect.width, height: minYLabelSize.height), withAttributes: [NSFontAttributeName: axisFont, NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: paragraphStyle])
        
        CGContextRestoreGState(ctx)
    }
    
    private func drawDataInRect(rect: CGRect) {
        guard let dataSource = dataSource else {
            fatalError("No data source")
        }
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        let lineWidth: CGFloat = 1.0
        CGContextTranslateCTM(ctx, rect.minX, rect.minY)
        let maxYValue: Int
        if let customMaxYValue = customMaxYValue {
            maxYValue = customMaxYValue
        } else if let _maxYValue = dataSource.maxYValue {
            maxYValue = _maxYValue
        } else {
            maxYValue = 1
        }
        let minYValue: Int
        if let customMinYValue = customMinYValue {
            minYValue = customMinYValue
        } else if let _minYValue = dataSource.minYValue {
            minYValue = _minYValue
        } else {
            minYValue = 0
        }
        let horizontalSpace = (rect.width / CGFloat(dataSource.numberOfObjects() - 1))
        let verticalSpace = rect.height / CGFloat(maxYValue - minYValue)
        
        let initialDataPoint: CGPoint
        if let initialValue = dataSource.first?.yValue {
            initialDataPoint = CGPoint(x: 0, y: rect.height - verticalSpace * CGFloat(initialValue))
        } else {
            initialDataPoint = CGPoint(x: 0, y: rect.height)
        }
        var lastPointAndIndex: (point: CGPoint, index: Int) = (initialDataPoint, 0)
        for i in 0..<dataSource.numberOfObjects() {
            CGContextSaveGState(ctx)
            guard let data = dataSource.chartView(self, dataAtIndex: i),
                let yValue = data.yValue else {
                continue
            }
            let currentPoint = CGPoint(x: horizontalSpace * CGFloat(i), y: rect.height - verticalSpace * CGFloat(yValue))
            
            //Draw data point circle
            let circleRadius: CGFloat = 2.0
            let circle = UIBezierPath(arcCenter: currentPoint, radius: circleRadius, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: true)
            circle.lineWidth = 2.0
            circle.stroke()
            
            //At first point, just draw a circle
            if i == 0 {
                CGContextRestoreGState(ctx)
                lastPointAndIndex = (currentPoint, i)
                continue
            }
            
            //Draw chart line
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            path.lineJoinStyle = .Round
            path.lineCapStyle = .Round
            
            //Calculate intersection between line and circle
            let rate = circleRadius / distanceBetween(lastPointAndIndex.point, p2: currentPoint)
            let startIntersection = CGPoint(
                x: lastPointAndIndex.point.x + rate * (currentPoint.x - lastPointAndIndex.point.x),
                y: lastPointAndIndex.point.y + rate * (currentPoint.y - lastPointAndIndex.point.y))
            
            let endIntersection = CGPoint(
                x: currentPoint.x - rate * (currentPoint.x - lastPointAndIndex.point.x),
                y: currentPoint.y - rate * (currentPoint.y - lastPointAndIndex.point.y))
            
            path.moveToPoint(startIntersection)
            
            if lastPointAndIndex.index != i - 1 {
                let pattern: [CGFloat] = [3.0, 6.0]
                path.setLineDash(pattern, count: pattern.count, phase: 0)
            }
            path.addLineToPoint(endIntersection)
            path.stroke()
            CGContextRestoreGState(ctx)
            lastPointAndIndex = (currentPoint, i)
        }
        CGContextRestoreGState(ctx)
    }
}
