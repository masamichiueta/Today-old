//
//  StoryboardHandlerType.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/17.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        case GetStarted
        case Main
        case Today
        case Activity
    }
    
    class func storyboard(storyboard: Storyboard, bundle: NSBundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController where T: StoryboardHandlerType>() -> T {
        let optionalViewController = self.instantiateViewControllerWithIdentifier(T.storyboardIdentifier)
        
        guard let viewController = optionalViewController as? T  else {
            fatalError("Couldn’t instantiate view controller with identifier \(T.storyboardIdentifier)")
        }
        
        return viewController
    }
}

protocol StoryboardHandlerType {
    static var storyboardIdentifier: String { get }
}

extension StoryboardHandlerType where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(self)
    }
}
