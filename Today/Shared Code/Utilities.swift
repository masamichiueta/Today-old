//
//  Utilities.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/28.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit

enum ScoreColorType {
    case High
    case Middle
    case Low
}

extension UIColor {
    
    static func scoreColor(type: ScoreColorType) -> UIColor {
        switch type {
        case .High:
            return UIColor.redColor()
        case .Middle:
            return UIColor.greenColor()
        case .Low:
            return UIColor.blueColor()
        }
    }
}