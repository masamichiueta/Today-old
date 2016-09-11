//
//  Utilities.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/24.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit

public func localize(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

extension UserDefaults {
    public func clean() {
        for key in self.dictionaryRepresentation().keys {
            self.removeObject(forKey: key)
        }
    }
}

extension Date {
    public static func numberOfDaysFromDateTime(_ fromDateTime: Date, toDateTime: Date, inTimeZone timeZone: TimeZone? = nil) -> Int {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        let difference = calendar.dateComponents([.day], from: fromDateTime, to: toDateTime)
        return difference.day!
    }
}

public enum ColorType {
    case red, orange, yellow, green, blue, darkViewBackground, darkCellBackground, darkSectionHeader, darkSeparator, darkDetailText, darkTextField, darkBar
}

extension UIColor {
    
    public class func applicationColor(type: ColorType) -> UIColor {
        switch type {
        case .red:
            return UIColor(red: 250.0/255.0, green: 17.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        case .orange:
            return UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        case .yellow:
            return UIColor(red: 255.0/255.0, green: 230.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        case .green:
            return UIColor(red: 4.0/255.0, green: 222.0/255.0, blue: 113.0/255.0, alpha: 1.0)
        case .blue:
            return UIColor(red: 32.0/255.0, green: 148.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        case .darkViewBackground:
            return UIColor(red: 37.0/255.0, green: 38.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        case .darkCellBackground:
            return UIColor(red: 42.0/255.0, green: 44.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        case .darkSectionHeader:
            return UIColor(red: 48.0/255.0, green: 50.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        case .darkSeparator:
            return UIColor(red: 70.0/255.0, green: 72.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        case .darkDetailText:
            return UIColor(red: 145.0/255.0, green: 147.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        case .darkTextField:
            return UIColor(red: 23.0/255.0, green: 26.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        case .darkBar:
            return UIColor(red: 35.0/255.0, green: 34.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        }
            
    }
}
