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

public final class Today: NSManagedObject {
    @NSManaged public internal(set) var date: Date
    @NSManaged public internal(set) var score: Int64
    
    public var type: TodayType {
        return Today.type(Int(score))
    }
    
    public var color: UIColor {
        return type.color()
    }
    
    public static var masterScores: [Int] {
        return scoreRange.sorted {
            $0 > $1
        }
    }
    
    public static var maxMasterScore: Int {
        return Today.masterScores.first!
    }
    
    public static var minMasterScore: Int {
        return Today.masterScores.last!
    }
    
    public static func average(_ moc: NSManagedObjectContext) -> Int {
        let request = NSFetchRequest<Today>(entityName: Today.entityName)
        request.resultType = .dictionaryResultType
        
        let keyPathExpression = NSExpression(forKeyPath: "score")
        let averageExpression = NSExpression(forFunction: "average:", arguments: [keyPathExpression])
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "averageScore"
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        request.propertiesToFetch = [expressionDescription]
        
        do {
            let objects = try moc.fetch(request)
            let object = objects[0]
            guard let averageScore = object.value(forKey: "averageScore") as? Int else {
                fatalError("Invalid key")
            }
            return averageScore
        } catch {
            return 0
        }
    }
    
    public static func type(_ score: Int) -> TodayType {
        
        let step = scoreRange.count / TodayType.count
        
        switch score {
        case 0...step:
            return .Poor
        case (step + 1)...(step * 2):
            return .Fair
        case (step * 2 + 1)...(step * 3):
            return .Average
        case (step * 3 + 1)...(step * 4):
            return .Good
        default:
            return .Excellent
        }
    }
}

////MARK: - ManagedObjectType
//extension Today: ManagedObjectType {
//    public static var entityName: String {
//        return "Today"
//    }
//    
//    public static var defaultSortDescriptors: [SortDescriptor] {
//        return [SortDescriptor(key: "date", ascending: false)]
//    }
//}

//MARK: - TodayType
private let goodIconImageName = "good_face_icon_"
private let averageIconImageName = "average_face_icon_"
private let poorIconImageName = "poor_face_icon_"

public enum TodayIconSize: String {
    case TwentyEight = "28"
    case Fourty = "40"
}

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
    
    public func gradientColor() -> CGGradient {
        let locations: [CGFloat] = [0.0, 1.0]
        let colors: [CGColor]
        switch self {
        case .Excellent:
            colors = [
                UIColor.todayGradientRedStartColor().cgColor,
                UIColor.todayGradientRedEndColor().cgColor
            ]
        case .Good:
            colors = [
                UIColor.todayGradientOrangeStartColor().cgColor,
                UIColor.todayGradientOrangeEndColor().cgColor
            ]
        case .Average:
            colors = [
                UIColor.todayGradientYellowStartColor().cgColor,
                UIColor.todayGradientYellowEndColor().cgColor
            ]
        case .Fair:
            colors = [
                UIColor.todayGradientGreenStartColor().cgColor,
                UIColor.todayGradientGreenEndColor().cgColor
            ]
        case .Poor:
            colors = [
                UIColor.todayGradientBlueStartColor().cgColor,
                UIColor.todayGradientBlueEndColor().cgColor
            ]
        }
        return CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: locations)!
    }
    
    public func icon(_ size: TodayIconSize) -> UIImage {
        switch self {
        case .Excellent, .Good:
            guard let image = UIImage(named: goodIconImageName + size.rawValue) else {
                fatalError("Wrong image name for good")
            }
            return image.withRenderingMode(.alwaysTemplate)
        case .Average, .Fair:
            guard let image = UIImage(named: averageIconImageName + size.rawValue) else {
                fatalError("Wrong image name for average")
            }
            return image.withRenderingMode(.alwaysTemplate)
        case .Poor:
            guard let image = UIImage(named: poorIconImageName + size.rawValue) else {
                fatalError("Wrong image name for poor")
            }
            return image.withRenderingMode(.alwaysTemplate)
        }
    }
    
    public func iconName(_ size: TodayIconSize) -> String {
        switch self {
        case .Excellent, .Good:
            return goodIconImageName + size.rawValue
        case .Average, .Fair:
            return averageIconImageName + size.rawValue
        case .Poor:
            return poorIconImageName + size.rawValue
        }
    }
}
