//
//  Today.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData

private let scoreRange = [Int](0...10)

public final class Today: ManagedObject {
    @NSManaged public private(set) var date: NSDate
    @NSManaged public private(set) var score: Int64
    
    public var type: TodayType {
        return Today.type(Int(score))
    }
    
    public var color: UIColor {
        return type.color()
    }
    
    public static var masterScores: [Int] {
        return scoreRange.sort {
            $0 > $1
        }
    }
    
    public static var maxMasterScore: Int {
        return Today.masterScores.first!
    }
    
    public static var minMasterScore: Int {
        return Today.masterScores.last!
    }
    
    public static func average(moc: NSManagedObjectContext) -> Int {
        let request = NSFetchRequest(entityName: Today.entityName)
        request.resultType = .DictionaryResultType
        
        let keyPathExpression = NSExpression(forKeyPath: "score")
        let averageExpression = NSExpression(forFunction: "average:", arguments: [keyPathExpression])
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "averageScore"
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .Integer64AttributeType
        
        request.propertiesToFetch = [expressionDescription]
        
        do {
            let objects = try moc.executeFetchRequest(request)
            guard let averageScore = objects[0]["averageScore"] as? Int else {
                fatalError("Invalid key")
            }
            return averageScore
        } catch {
            return 0
        }
    }
    
    public static func type(score: Int?) -> TodayType {
        guard let s = score else {
            return .Poor
        }
        
        let step = scoreRange.count / TodayType.count
        
        switch s {
        case 0...step:
            return .Poor
        case step+1...step*2:
            return .Fair
        case step*2+1...step*3:
            return .Average
        case step*3+1...step*4:
            return .Good
        default:
            return .Excellent
        }
    }
    
    public static func created(moc: NSManagedObjectContext, forDate date: NSDate) -> Bool {
        
        let todays = Today.fetchInContext(moc, configurationBlock: {
            request in
            request.sortDescriptors = Today.defaultSortDescriptors
            request.fetchLimit = 1
        })
        if todays.count == 0 {
            return false
        }
        return NSCalendar.currentCalendar().isDate(date, inSameDayAsDate: todays[0].date)
    }
    
    public static func todaysInWeek(moc: NSManagedObjectContext) -> [Today] {
        let todays = Today.fetchInContext(moc, configurationBlock: {
            request in
            request.fetchLimit = 7
            request.sortDescriptors = Today.defaultSortDescriptors
            let today = NSDate()
            let dayOneWeekAgo = NSDate(timeInterval: -(7 * 24 * 60 * 60), sinceDate: today)
            request.predicate = NSPredicate(format: "date => %@ && date <= %@", dayOneWeekAgo, today)
        })
        
        return todays
    }
    
    public static func insertIntoContext(moc: NSManagedObjectContext, score: Int64, date: NSDate) -> Today {
        let today: Today = moc.insertObject()
        today.score = score
        today.date = date
        return today
    }
}

extension Today: ManagedObjectType {
    public static var entityName: String {
        return "Today"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}

private let goodIconImageName = "good_face_icon_"
private let averageIconImageName = "average_face_icon_"
private let poorIconImageName = "poor_face_icon_"


public enum TodayType: String {
    case Excellent
    case Good
    case Average
    case Fair
    case Poor
    
    static let count = 5
    
    public func color() -> UIColor {
        switch self {
        case .Excellent:
            return UIColor.todayRedColor()
        case .Good:
            return UIColor.todayOrangeColor()
        case .Average:
            return UIColor.todayYellowColor()
        case .Fair:
            return UIColor.todayGreenColor()
        case .Poor:
            return UIColor.todayBlueColor()
        }
    }
    
    public func icon(size: String) -> UIImage {
        switch self {
        case .Excellent, .Good:
            guard let image = UIImage(named: goodIconImageName + size) else {
                fatalError("Wrong image name for good")
            }
            return image.imageWithRenderingMode(.AlwaysTemplate)
        case .Average, .Fair:
            guard let image = UIImage(named: averageIconImageName + size) else {
                fatalError("Wrong image name for average")
            }
            return image.imageWithRenderingMode(.AlwaysTemplate)
        case .Poor:
            guard let image = UIImage(named: poorIconImageName + size) else {
                fatalError("Wrong image name for poor")
            }
            return image.imageWithRenderingMode(.AlwaysTemplate)
        }
    }
}
