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
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Today> {
        return NSFetchRequest<Today>(entityName: "Today");
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
    
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
    
    public static func count(_ moc: NSManagedObjectContext) -> Int {
        let reqeust: NSFetchRequest<Today> = Today.fetchRequest()
        do {
            let count = try moc.count(for: reqeust)
            return count
        } catch {
            fatalError()
        }
    }
    
    public static func type(_ score: Int) -> TodayType {
        
        let step = scoreRange.count / TodayType.count
        
        switch score {
        case 0...step:
            return .poor
        case (step + 1)...(step * 2):
            return .fair
        case (step * 2 + 1)...(step * 3):
            return .average
        case (step * 3 + 1)...(step * 4):
            return .good
        default:
            return .excellent
        }
    }
}

//MARK: - TodayType
private let excellentIconImageName = "excellent_face_icon_"
private let goodIconImageName = "good_face_icon_"
private let averageIconImageName = "average_face_icon_"
private let fairIconImageName = "fair_face_icon_"
private let poorIconImageName = "poor_face_icon_"

public enum TodayIconSize: String {
    case twentyEight = "28"
    case hundred = "100"
}

public enum TodayType: String {
    case excellent
    case good
    case average
    case fair
    case poor
    
    static let count = 5
    
    public func color() -> UIColor {
        switch self {
        case .excellent:
            return UIColor.applicationColor(type: .red)
        case .good:
            return UIColor.applicationColor(type: .orange)
        case .average:
            return UIColor.applicationColor(type: .yellow)
        case .fair:
            return UIColor.applicationColor(type: .green)
        case .poor:
            return UIColor.applicationColor(type: .blue)
        }
    }
  
    public func icon(_ size: TodayIconSize) -> UIImage {
        switch self {
        case .excellent:
            guard let image = UIImage(named: excellentIconImageName + size.rawValue) else {
                fatalError("Wrong image name for good")
            }
            return image
        case .good:
            guard let image = UIImage(named: goodIconImageName + size.rawValue) else {
                fatalError("Wrong image name for good")
            }
            return image
        case .average:
            guard let image = UIImage(named: averageIconImageName + size.rawValue) else {
                fatalError("Wrong image name for good")
            }
            return image
        case .fair:
            guard let image = UIImage(named: fairIconImageName + size.rawValue) else {
                fatalError("Wrong image name for average")
            }
            return image
        case .poor:
            guard let image = UIImage(named: poorIconImageName + size.rawValue) else {
                fatalError("Wrong image name for poor")
            }
            return image
        }
    }
    
    public func iconName(_ size: TodayIconSize) -> String {
        switch self {
        case .excellent:
            return excellentIconImageName + size.rawValue
        case .good:
            return goodIconImageName + size.rawValue
        case .average:
            return averageIconImageName + size.rawValue
        case .fair:
            return fairIconImageName + size.rawValue
        case .poor:
            return poorIconImageName + size.rawValue
        }
    }
}
