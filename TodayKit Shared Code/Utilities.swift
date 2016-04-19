//
//  Utilities.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/24.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit

public func localize(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

extension CGPoint {
    public static func distanceBetween(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2))
    }
}

extension NSUserDefaults {
    public func clean() {
        for key in self.dictionaryRepresentation().keys {
            self.removeObjectForKey(key)
        }
    }
}

extension NSURL {
    
    static func temporaryURL() -> NSURL {
        
        do {
            return try NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent(NSUUID().UUIDString)
        } catch {
            fatalError()
        }
    }
    
    static var documentsURL: NSURL {
        do {
            return try NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        } catch {
            fatalError()
        }
    }
}

extension NSDate {
    public static func numberOfDaysFromDateTime(fromDateTime: NSDate, toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        var fromDate: NSDate?, toDate: NSDate?
        
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: fromDateTime)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        return difference.day
    }
    
    public static func nextWeekDatesFromDate(date: NSDate) -> [NSDate] {
        return [Int](0..<7).map { i -> NSDate in
            let comp =  NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday, .Hour, .Minute, .Second], fromDate: date)
            comp.day = comp.day + i
            return NSCalendar.currentCalendar().dateFromComponents(comp)!
        }
    }
    
    public static func previousWeekDatesFromDate(date: NSDate) -> [NSDate] {
        return [Int](1...7).map { i -> NSDate in
            let comp =  NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday, .Hour, .Minute, .Second], fromDate: date)
            comp.day = comp.day - 7 + i
            return NSCalendar.currentCalendar().dateFromComponents(comp)!
        }
    }
    
    public static func nextMonthDatesFromDate(date: NSDate) -> [NSDate] {
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday, .Hour, .Minute, .Second], fromDate: date)
        comp.month = comp.month + 1
        
        guard let toDateTime = NSCalendar.currentCalendar().dateFromComponents(comp) else {
            fatalError("Wrong components")
        }
        
        let numberOfDaysToNextMonth = NSDate.numberOfDaysFromDateTime(date, toDateTime: toDateTime)
        
        return [Int](0..<numberOfDaysToNextMonth).map { i -> NSDate in
            let comp =  NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday, .Hour, .Minute, .Second], fromDate: date)
            comp.day = comp.day + i
            return NSCalendar.currentCalendar().dateFromComponents(comp)!
        }
    }
    
    public static func previousMonthDatesFromDate(date: NSDate) -> [NSDate] {
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday, .Hour, .Minute, .Second], fromDate: date)
        comp.month = comp.month - 1
        
        guard let fromDateTime = NSCalendar.currentCalendar().dateFromComponents(comp) else {
            fatalError("Wrong components")
        }
        let numberOfDaysFromLastMonth = NSDate.numberOfDaysFromDateTime(fromDateTime, toDateTime: date)        
        
        return [Int](1...numberOfDaysFromLastMonth).map { i -> NSDate in
            let comp =  NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday, .Hour, .Minute, .Second], fromDate: date)
            comp.day = comp.day - numberOfDaysFromLastMonth + i
            return NSCalendar.currentCalendar().dateFromComponents(comp)!
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
