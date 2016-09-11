//
//  TodayProducts.swift
//  Today
//
//  Created by UetaMasamichi on 9/11/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import Foundation

struct TodayProducts {
    private static let Prefix = "com.uetamasamichi.Today."
    private static let Beer = Prefix + "Beer"
    
    static let productIdentifiers: Set = [TodayProducts.Beer]
    
    static func resourceNameForProductIdentifier(productIdentifier: String) -> String? {
        return productIdentifier.components(separatedBy: ".").last
    }

}
