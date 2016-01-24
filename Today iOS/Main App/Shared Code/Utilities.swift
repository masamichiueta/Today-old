//
//  Utilities.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/11.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

public func frameworkBundle(name: String) -> NSBundle? {
    let frameworkDirPath = NSBundle.mainBundle().privateFrameworksPath! as NSString
    let frameworkBundlePath = frameworkDirPath.stringByAppendingPathComponent(name)
    let frameworkBundle = NSBundle(path: frameworkBundlePath)
    return frameworkBundle
}

public func localize(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
