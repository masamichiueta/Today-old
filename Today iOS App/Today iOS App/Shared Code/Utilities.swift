//
//  Utilities.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/11.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

public func frameworkBundle(name: String) -> NSBundle? {
    let frameworkDirPath = NSBundle.mainBundle().privateFrameworksPath! as NSString
    let frameworkBundlePath = frameworkDirPath.stringByAppendingPathComponent(name)
    let frameworkBundle = NSBundle(path: frameworkBundlePath)
    return frameworkBundle
}

public func localize(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

public func distanceBetween(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2))
}
