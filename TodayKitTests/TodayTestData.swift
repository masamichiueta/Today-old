//
//  TodayTestData.swift
//  Today
//
//  Created by UetaMasamichi on 4/23/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import Foundation

struct TodayTestModel {
    let score: Int
    let date: NSDate
    
    init(score: Int, date: NSDate) {
        self.score = score
        self.date = date
    }
}

struct TodayTestData {
    
    // [Today, Today-1, Today-2, Today-3, Today-4, Today-5]
    static var streak1: [NSDate] = {
        var dates = [NSDate]()
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
        for _ in 0 ..< 6 {
            let date = NSCalendar.currentCalendar().dateFromComponents(comp)
            dates.append(date!)
            comp.day = comp.day - 1
        }
        return dates
    }()
    
    // [Today-8, Today-9, Today-10, Today-11]
    static var streak2: [NSDate] = {
        var dates = [NSDate]()
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
        comp.day = comp.day - 8
        for _ in 0 ..< 4 {
            let date = NSCalendar.currentCalendar().dateFromComponents(comp)
            dates.append(date!)
            comp.day = comp.day - 1
        }
        return dates
    }()
    
    // [Today-15, Today-16, Today-17, Today-18]
    static var streak3: [NSDate] = {
        var dates = [NSDate]()
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
        comp.day = comp.day - 15
        for _ in 0 ..< 4 {
            let date = NSCalendar.currentCalendar().dateFromComponents(comp)
            dates.append(date!)
            comp.day = comp.day - 1
        }
        return dates
    }()
    
    // [Today - 21]
    static var streak4: [NSDate] = {
        var dates = [NSDate]()
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
        comp.day = comp.day - 21
        let date = NSCalendar.currentCalendar().dateFromComponents(comp)
        dates.append(date!)
        return dates
    }()
    
    
    
    static func createTestData() -> [TodayTestModel] {
        return [
            TodayTestModel(score: 0, date: streak1[0]),
            TodayTestModel(score: 1, date: streak1[1]),
            TodayTestModel(score: 2, date: streak1[2]),
            TodayTestModel(score: 3, date: streak1[3]),
            TodayTestModel(score: 4, date: streak1[4]),
            TodayTestModel(score: 5, date: streak1[5]),
            TodayTestModel(score: 6, date: streak2[0]),
            TodayTestModel(score: 7, date: streak2[1]),
            TodayTestModel(score: 8, date: streak2[2]),
            TodayTestModel(score: 9, date: streak2[3]),
            TodayTestModel(score: 10, date: streak3[0]),
            TodayTestModel(score: 2, date: streak3[1]),
            TodayTestModel(score: 3, date: streak3[2]),
            TodayTestModel(score: 4, date: streak3[3]),
            TodayTestModel(score: 4, date: streak4[0])
        ]
    }

}