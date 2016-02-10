//
//  Utilities.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/24.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit

extension NSURL {
    
    static func temporaryURL() -> NSURL {
        
        do {
            return try NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent(NSUUID().UUIDString)
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
    public func numberOfDaysUntilDateTime(toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        var fromDate: NSDate?, toDate: NSDate?
        
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        return difference.day
    }
    
    public static func datesToNextWeekDateFromDate(date: NSDate) -> [NSDate] {
        return [Int](0..<7).map { i -> NSDate in
            let comp =  NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday, .Hour, .Minute], fromDate: date)
            comp.day = comp.day + i
            return NSCalendar.currentCalendar().dateFromComponents(comp)!
        }
    }
    
    public static func datesFromPreviousWeekDateToDate(date: NSDate) -> [NSDate] {
        return [Int](1...7).map { i -> NSDate in
            let comp =  NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday, .Hour, .Minute], fromDate: date)
            comp.day = comp.day - 7 + i
            return NSCalendar.currentCalendar().dateFromComponents(comp)!
        }
    }
    
    public static func datesToNextMonthDateFromDate(date: NSDate) -> [NSDate] {
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday, .Hour, .Minute], fromDate: date)
        comp.month = comp.month + 1
        let numberOfDaysToNextMonth = date.numberOfDaysUntilDateTime(NSCalendar.currentCalendar().dateFromComponents(comp)!)
        
        return [Int](0..<numberOfDaysToNextMonth).map { i -> NSDate in
            let comp =  NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday, .Hour, .Minute], fromDate: date)
            comp.day = comp.day + i
            return NSCalendar.currentCalendar().dateFromComponents(comp)!
        }
    }
    
    public static func datesFromPreviousMonthDateToDate(date: NSDate) -> [NSDate] {
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday, .Hour, .Minute], fromDate: date)
        comp.month = comp.month - 1
        let numberOfDaysFromLastMonth = NSCalendar.currentCalendar().dateFromComponents(comp)!.numberOfDaysUntilDateTime(date)

        
        return [Int](1...numberOfDaysFromLastMonth).map { i -> NSDate in
            let comp =  NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday, .Hour, .Minute], fromDate: date)
            comp.day = comp.day - numberOfDaysFromLastMonth + i
            return NSCalendar.currentCalendar().dateFromComponents(comp)!
        }
    }

}

extension UIColor {
    public class func todayRedColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    }
    
    public class func todayOrangeColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0/255.0, alpha: 1.0)
    }
    
    public class func todayYellowColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0/255.0, alpha: 1.0)
    }
    
    public class func todayGreenColor() -> UIColor {
        return UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    }
    
    public class func todayBlueColor() -> UIColor {
        return UIColor(red: 52.0/255.0, green: 170.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    }
    
    public class func todayGradientRedStartColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    }
    
    public class func todayGradientRedEndColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 42.0/255.0, blue: 104.0/255.0, alpha: 1.0)
    }
    
    public class func todayGradientOrangeStartColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
    public class func todayGradientOrangeEndColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    }
    
    public class func todayGradientYellowStartColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 219.0/255.0, blue: 76.0/255.0, alpha: 1.0)
    }
    
    public class func todayGradientYellowEndColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 205.0/255.0, blue: 2.0/255.0, alpha: 1.0)
    }
    
    public class func todayGradientGreenStartColor() -> UIColor {
        return UIColor(red: 135.0/255.0, green: 252.0/255.0, blue: 112.0/255.0, alpha: 1.0)
    }
    
    public class func todayGradientGreenEndColor() -> UIColor {
        return UIColor(red: 11.0/255.0, green: 211.0/255.0, blue: 24.0/255.0, alpha: 1.0)
    }
    
    public class func todayGradientBlueStartColor() -> UIColor {
        return UIColor(red: 26.0/255.0, green: 214.0/255.0, blue: 253.0/255.0, alpha: 1.0)
    }
    
    public class func todayGradientBlueEndColor() -> UIColor {
        return UIColor(red: 29.0/255.0, green: 98.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    }
}
