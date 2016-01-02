//
//  CircleView.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/02.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

@IBDesignable class CircleView: UIView {
    
    @IBInspectable var color: UIColor = UIColor.clearColor() {
        didSet {
            setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(ctx, color.CGColor)
        CGContextFillEllipseInRect(ctx, self.bounds)
    }
}
