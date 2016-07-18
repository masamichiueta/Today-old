//
//  BorderButton.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/13.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

@IBDesignable class BorderButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear() {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}
