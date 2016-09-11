//
//  Utilities.swift
//  Today
//
//  Created by UetaMasamichi on 9/11/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    func updateTintColor(_ color: UIColor) {
        self.tabBarController?.tabBar.tintColor = color
        self.navigationController?.navigationBar.tintColor = color
    }
    
    
}
