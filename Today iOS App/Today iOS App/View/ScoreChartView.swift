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
        let clipPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10.0)
        clipPath.addClip()
        
        drawBackgroundGradient()
        
        let xValueHeight: CGFloat = 40.0
        let yValueWidth: CGFloat = 40.0
        let chartHorizontalMargin: CGFloat = 16.0
        let chartVerticalMargin: CGFloat = 16.0
        
        let borderRect = CGRect(
            origin: CGPoint(
                x: summaryStackViewLeadingConstraint.constant,
                y: CGRectGetMaxY(summaryStackView.frame) + summaryStackViewTopConstraint.constant
            ),
            size: CGSize(
                width: CGRectGetWidth(self.frame) - summaryStackViewLeadingConstraint.constant * 2,
                height: CGRectGetHeight(self.frame) - CGRectGetHeight(summaryStackView.frame) - summaryStackViewTopConstraint.constant - xValueHeight))
        drawHorizontalLineInRect(borderRect)
        
        let xLabelRect = CGRect(
            origin: CGPoint(
                x: CGRectGetMinX(borderRect) + chartHorizontalMargin,
                y: CGRectGetMaxY(borderRect)),
            size: CGSize(
                width: CGRectGetWidth(borderRect) - yValueWidth - chartHorizontalMargin * 2,
                height: xValueHeight))
        drawXLabelInRect(xLabelRect)
        
        let yLabelRect = CGRect(
            origin: CGPoint(
                x: CGRectGetMaxX(borderRect) - yValueWidth,
                y: CGRectGetMinY(borderRect) + chartVerticalMargin),
            size: CGSize(
                width: yValueWidth,
                height: CGRectGetHeight(borderRect) - chartVerticalMargin * 2))
        drawYLabelInRect(yLabelRect)
        
        let dataRect = CGRect(
            origin: CGPoint(
                x: CGRectGetMinX(borderRect) + chartHorizontalMargin,
                y: CGRectGetMinY(borderRect) + chartVerticalMargin),
            size: CGSize(
                width: CGRectGetWidth(xLabelRect),
                height: CGRectGetHeight(yLabelRect)))
        
        drawDataInRect(dataRect)
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
    }
    
    //MARK: - Draiwng
    private func drawBackgroundGradient() {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        let startPoint = CGPoint(x: CGRectGetMidX(self.bounds), y: 0)
        let endPoint = CGPoint(x: CGRectGetMidX(self.bounds), y: CGRectGetMaxY(self.bounds))
        if let lastValue = dataSource?.lastValue() {
            gradient = Today.type(lastValue).gradientColor()
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
        horizontalLine.moveToPoint(CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMinY(rect)))
        horizontalLine.addLineToPoint(CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMinY(rect)))
        CGContextSaveGState(ctx)
        horizontalLine.stroke()
        CGContextTranslateCTM(ctx, 0.0, CGRectGetHeight(rect))
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
        let labelSpace = (CGRectGetWidth(rect) / CGFloat(dataSource.numberOfObjects() - 1))
        CGContextTranslateCTM(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect))
        
        for i in 0..<dataSource.numberOfObjects() {
            guard let label = dataSource.chartView(self, xValueForAtXIndex: i) else {
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
        CGContextTranslateCTM(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect))
        
        guard let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as? NSMutableParagraphStyle else {
            fatalError("Wrong paragraph style")
        }
        paragraphStyle.alignment = .Right
        
        let maxYLabel: String
        if let customMaxYValue = customMaxYValue {
            maxYLabel = "\(customMaxYValue)"
        } else if let maxYValue = dataSource.maxYValue() {
            maxYLabel = "\(maxYValue)"
        } else {
            maxYLabel = ""
        }
        
        let maxYLabelSize = maxYLabel.sizeWithAttributes([NSFontAttributeName: axisFont])
        maxYLabel.drawInRect(CGRect(x: 0.0, y: -(maxYLabelSize.height / 2.0), width: CGRectGetWidth(rect), height: maxYLabelSize.height), withAttributes: [NSFontAttributeName: axisFont, NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: paragraphStyle])
        
        let minYLabel: String
        if let customMinYValue = customMinYValue {
            minYLabel = "\(customMinYValue)"
        } else if let minYValue = dataSource.minYValue() {
            minYLabel = "\(minYValue)"
        } else {
            minYLabel = ""
        }
        
        let minYLabelSize = minYLabel.sizeWithAttributes([NSFontAttributeName: axisFont])
        minYLabel.drawInRect(CGRect(x: 0.0, y: CGRectGetHeight(rect) - minYLabelSize.height / 2.0, width: CGRectGetWidth(rect), height: minYLabelSize.height), withAttributes: [NSFontAttributeName: axisFont, NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: paragraphStyle])
        
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
        
        CGContextTranslateCTM(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect))
        let maxYValue: Int
        if let customMaxYValue = customMaxYValue {
            maxYValue = customMaxYValue
        } else if let _maxYValue = dataSource.maxYValue() {
            maxYValue = _maxYValue
        } else {
            maxYValue = 1
        }
        
        let minYValue: Int
        if let customMinYValue = customMinYValue {
            minYValue = customMinYValue
        } else if let _minYValue = dataSource.minYValue() {
            minYValue = _minYValue
        } else {
            minYValue = 0
        }
        
        let horizontalSpace = (CGRectGetWidth(rect) / CGFloat(dataSource.numberOfObjects() - 1))
        let verticalSpace = CGRectGetHeight(rect) / CGFloat(maxYValue - minYValue)
        
        let initialDataPoint = CGPoint(x: -lineWidth / 2.0, y: CGRectGetHeight(rect))
        var lastPointAndIndex: (point: CGPoint, index: Int) = (initialDataPoint, 0)
        for i in 0..<dataSource.numberOfObjects() {
            CGContextSaveGState(ctx)
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            path.lineJoinStyle = .Round
            path.lineCapStyle = .Round
            path.moveToPoint(lastPointAndIndex.point)
            guard let yValue = dataSource.chartView(self, yValueForAtXIndex: i) else {
                continue
            }
            if lastPointAndIndex.index != i - 1 {
                let pattern: [CGFloat] = [3.0, 6.0]
                path.setLineDash(pattern, count: pattern.count, phase: 0)
            }
            let currentPoint = CGPoint(x: horizontalSpace * CGFloat(i), y: CGRectGetHeight(rect) - verticalSpace * CGFloat(yValue))
            path.addLineToPoint(currentPoint)
            path.stroke()
            CGContextRestoreGState(ctx)
            lastPointAndIndex = (currentPoint, i)
        }
        CGContextRestoreGState(ctx)
    }
    
    private func pathFromDataInRect(rect: CGRect) -> UIBezierPath {
        guard let dataSource = dataSource else {
            fatalError("No data source")
        }
        let path = UIBezierPath()
        let lineWidth: CGFloat = 1.0
        path.lineWidth = lineWidth
        path.lineJoinStyle = .Round
        path.lineCapStyle = .Round
        
        let maxYValue: Int
        if let customMaxYValue = customMaxYValue {
            maxYValue = customMaxYValue
        } else if let _maxYValue = dataSource.maxYValue() {
            maxYValue = _maxYValue
        } else {
            maxYValue = 1
        }
        
        let minYValue: Int
        if let customMinYValue = customMinYValue {
            minYValue = customMinYValue
        } else if let _minYValue = dataSource.minYValue() {
            minYValue = _minYValue
        } else {
            minYValue = 0
        }
        
        let horizontalSpace = (CGRectGetWidth(rect) / CGFloat(dataSource.numberOfObjects() - 1))
        let verticalSpace = CGRectGetHeight(rect) / CGFloat(maxYValue - minYValue)
        
        let initialDataPoint = CGPoint(x: CGRectGetMinX(rect) - lineWidth / 2.0, y: CGRectGetMinY(rect) + CGRectGetHeight(rect))
        var previousYValue: Int?
        path.moveToPoint(initialDataPoint)
        for i in 0..<dataSource.numberOfObjects() {
            guard let yValue = dataSource.chartView(self, yValueForAtXIndex: i) else {
                //Move x
                path.moveToPoint(CGPoint(x: horizontalSpace * CGFloat(i + 1), y: CGRectGetHeight(rect)))
                previousYValue = nil
                continue
            }
            if previousYValue != nil {
                path.addLineToPoint(CGPoint(x: horizontalSpace * CGFloat(i + 1), y: CGRectGetHeight(rect) - verticalSpace * CGFloat(yValue)))
                path.stroke()
            } else {
                path.moveToPoint(CGPoint(x: horizontalSpace * CGFloat(i + 1), y: CGRectGetHeight(rect) - verticalSpace * CGFloat(yValue)))
            }
            previousYValue = yValue
        }
        return path
    }
    
    //MARK: - Clipping Path
    private func bottomClipPathFromDataInRect(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.appendPath(pathFromDataInRect(rect))
        let currentPoint = path.currentPoint
        path.addLineToPoint(CGPoint(x: CGRectGetMaxX(rect), y: currentPoint.y))
        path.addLineToPoint(CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMinY(rect)))
        path.addLineToPoint(CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMinY(rect)))
        //path.addLineToPoint(CGPoint(x: CGRectGetMinX(rect), y: <#T##Double#>))
        //[path addLineToPoint:CGPointMake(CGRectGetMinX(rect), initialDataPoint_.y)];
        //[path addLineToPoint:CGPointMake(initialDataPoint_.x, initialDataPoint_.y)];
        path.closePath()
        return path
    }
}
