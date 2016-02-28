//
//  Utilities+iOS.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/28.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

extension UINavigationController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        guard let visibleViewController = visibleViewController else {
            return super.supportedInterfaceOrientations()
        }
        return visibleViewController.supportedInterfaceOrientations()
    }
    
    public override func shouldAutorotate() -> Bool {
        guard let visibleViewController = visibleViewController else {
            return super.shouldAutorotate()
        }
        return visibleViewController.shouldAutorotate()
    }
}

extension UITabBarController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        guard let selectedViewController = selectedViewController else {
            return super.supportedInterfaceOrientations()
        }
        return selectedViewController.supportedInterfaceOrientations()
        
    }
    
    public override func shouldAutorotate() -> Bool {
        guard let selectedViewController = selectedViewController else {
            return super.shouldAutorotate()
        }
        
        return selectedViewController.shouldAutorotate()
    }
}
