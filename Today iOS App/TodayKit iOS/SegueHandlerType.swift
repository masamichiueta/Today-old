//
//  SegueHandlerType.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit

public protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}


extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    public func segueIdentifierForSegue(_ segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
                fatalError("Unknown segue: \(segue))")
        }
        return segueIdentifier
    }
    
    public func performSegue(_ segueIdentifier: SegueIdentifier) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: nil)
    }
    
}
