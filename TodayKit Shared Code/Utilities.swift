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

extension CGPoint {
    public static func distanceBetween(_ p1: CGPoint, p2: CGPoint) -> CGFloat {
        return sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2))
    }
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
    
    public static func nextWeekDatesFromDate(_ date: Date) -> [Date] {
        return [Int](0..<7).map { i -> Date in
            var comp =  Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: date)
            comp.day = comp.day! + i
            return Calendar.current.date(from: comp)!
        }
    }
    
    public static func previousWeekDatesFromDate(_ date: Date) -> [Date] {
        return [Int](1...7).map { i -> Date in
            var comp =  Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: date)
            comp.day = comp.day! - 7 + i
            return Calendar.current.date(from: comp)!
        }
    }
    
    public static func nextMonthDatesFromDate(_ date: Date) -> [Date] {
        var comp = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: date)
        comp.month = comp.month! + 1
        
        guard let toDateTime = Calendar.current.date(from: comp) else {
            fatalError("Wrong components")
        }
        
        let numberOfDaysToNextMonth = Date.numberOfDaysFromDateTime(date, toDateTime: toDateTime)
        
        return [Int](0..<numberOfDaysToNextMonth).map { i -> Date in
            var comp =  Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: date)
            comp.day = comp.day! + i
            return Calendar.current.date(from: comp)!
        }
    }
    
    public static func previousMonthDatesFromDate(_ date: Date) -> [Date] {
        var comp = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: date)
        comp.month = comp.month! - 1
        
        guard let fromDateTime = Calendar.current.date(from: comp) else {
            fatalError("Wrong components")
        }
        let numberOfDaysFromLastMonth = Date.numberOfDaysFromDateTime(fromDateTime, toDateTime: date)        
        
        return [Int](1...numberOfDaysFromLastMonth).map { i -> Date in
            var comp =  Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: date)
            comp.day = comp.day! - numberOfDaysFromLastMonth + i
            return Calendar.current.date(from: comp)!
        }
    }
    
}

extension UIColor {
    public static func defaultTintColor() -> UIColor {
        return UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    }
    
    public static func todayRedColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    }
    
    public static func todayOrangeColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0/255.0, alpha: 1.0)
    }
    
    public static func todayYellowColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0/255.0, alpha: 1.0)
    }
    
    public static func todayGreenColor() -> UIColor {
        return UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    }
    
    public static func todayBlueColor() -> UIColor {
        return UIColor(red: 52.0/255.0, green: 170.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    }
    
    public static func todayGradientRedStartColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    }
    
    public static func todayGradientRedEndColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 42.0/255.0, blue: 104.0/255.0, alpha: 1.0)
    }
    
    public static func todayGradientOrangeStartColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
    public static func todayGradientOrangeEndColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    }
    
    public static func todayGradientYellowStartColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 219.0/255.0, blue: 76.0/255.0, alpha: 1.0)
    }
    
    public static func todayGradientYellowEndColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 205.0/255.0, blue: 2.0/255.0, alpha: 1.0)
    }
    
    public static func todayGradientGreenStartColor() -> UIColor {
        return UIColor(red: 135.0/255.0, green: 252.0/255.0, blue: 112.0/255.0, alpha: 1.0)
    }
    
    public static func todayGradientGreenEndColor() -> UIColor {
        return UIColor(red: 11.0/255.0, green: 211.0/255.0, blue: 24.0/255.0, alpha: 1.0)
    }
    
    public static func todayGradientBlueStartColor() -> UIColor {
        return UIColor(red: 26.0/255.0, green: 214.0/255.0, blue: 253.0/255.0, alpha: 1.0)
    }
    
    public static func todayGradientBlueEndColor() -> UIColor {
        return UIColor(red: 29.0/255.0, green: 98.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    }
}
