//
//  CircleView.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/28.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit


@IBDesignable class CircleView: UIView {

    @IBInspectable var borderColor: UIColor = UIColor.clearColor()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForInterfaceBuilder() {
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        self.layer.borderColor = borderColor.CGColor
    }
    

    override func drawRect(rect: CGRect) {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        self.layer.borderColor = borderColor.CGColor
    }

}
