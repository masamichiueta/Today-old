//
//  Today.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData

public final class Today: ManagedObject {
    @NSManaged public private(set) var date: NSDate
    @NSManaged public private(set) var score: Int64
    
    public var type: TodayType {
        return Today.type(Int(score))
    }
    
    public var color: UIColor {
        return type.color()
    }
    
    public static func insertIntoContext(moc: NSManagedObjectContext, score: Int64) -> Today {
        let today: Today = moc.insertObject()
        today.score = score
        today.date = NSDate()
        return today
    }
    
    public static var masterScores: [Int] {
        return scoreRange.sort {
            $0 > $1
        }
    }
    
    public static var maxScore: Int {
        return Today.masterScores.first!
    }
    
    public static var minScore: Int {
        return Today.masterScores.last!
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
    
    public static func animationImages(from: Int, to: Int) -> [UIImage] {
        
        guard let goodImage = UIImage(named: goodIconImageName), let averageImage = UIImage(named: averageIconImageName), let poorImage = UIImage(named: poorIconImageName) else {
            fatalError("Wrong image name")
        }
        
        let fromType = Today.type(from)
        let toType = Today.type(to)
        
        switch (fromType, toType) {
        case (.Excellent, .Excellent), (.Excellent, .Good), (.Good, .Excellent), (.Good, .Good):
            return [goodImage]
        case (.Excellent, .Average), (.Excellent, .Fair), (.Good, .Average), (.Good, .Fair):
            return [averageImage, goodImage]
        case (.Excellent, .Poor), (.Good, .Poor):
            return [poorImage, averageImage, goodImage]
        case (.Average, .Excellent), (.Average, .Good), (.Fair, .Excellent), (.Fair, .Good):
            return [averageImage, goodImage]
        case (.Average, .Average), (.Average, .Fair), (.Fair, .Fair), (.Fair, .Average):
            return [averageImage]
        case (.Average, .Poor), (.Fair, .Poor):
            return [averageImage, poorImage]
        case (.Poor, .Poor):
            return [poorImage]
        case (.Poor, .Average), (.Poor, .Fair):
            return [poorImage, averageImage]
        case (.Poor, .Good), (.Poor, .Excellent):
            return [poorImage, averageImage, goodImage]
        }
    }
}

private let scoreRange = [Int](0...10)

extension Today: ManagedObjectType {
    public static var entityName: String {
        return "Today"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}

private let redColor = "#FF3830"
private let orangeColor = "#FF7F00"
private let yellowColor = "#FFCC00"
private let greenColor = "#4CD964"
private let blueColor = "#34AADC"

private let goodIconImageName = "good_face_icon"
private let averageIconImageName = "average_face_icon"
private let poorIconImageName = "poor_face_icon"


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
            return UIColor(rgba: redColor)
        case .Good:
            return UIColor(rgba: orangeColor)
        case .Average:
            return UIColor(rgba: yellowColor)
        case .Fair:
            return UIColor(rgba: greenColor)
        case .Poor:
            return UIColor(rgba: blueColor)
        }
    }
    
    public func icon() -> UIImage {
        switch self {
        case .Excellent, .Good:
            guard let image = UIImage(named: goodIconImageName) else {
                fatalError("Wrong image name for good")
            }
            return image.imageWithRenderingMode(.AlwaysTemplate)
        case .Average, .Fair:
            guard let image = UIImage(named: averageIconImageName) else {
                fatalError("Wrong image name for average")
            }
            return image.imageWithRenderingMode(.AlwaysTemplate)
        case .Poor:
            guard let image = UIImage(named: poorIconImageName) else {
                fatalError("Wrong image name for poor")
            }
            return image.imageWithRenderingMode(.AlwaysTemplate)
        }
    }
}
