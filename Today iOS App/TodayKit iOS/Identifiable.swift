//
//  Identifiable.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/17.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

public protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable where Self: UIViewController {
    static var identifier: String {
        return String(self)
    }
}

extension UIStoryboard {
    public enum Storyboard: String {
        case GetStarted
        case Main
        case Today
        case Activity
    }
    
    public class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    public func instantiateViewController<T: UIViewController where T: Identifiable>() -> T {
        let optionalViewController = self.instantiateViewController(withIdentifier: T.identifier)
        
        guard let viewController = optionalViewController as? T  else {
            fatalError("Couldn’t instantiate view controller with identifier \(T.identifier)")
        }
        
        return viewController
    }
}

extension UITableView {
    public enum TableViewCellIdentifier: String {
        //iOS App
        case Cell
        case ActivityChartCell
        case ActivityAverageTotalCell
        case ActivityStreakCell
        case SettingCell
        case SettingSwitchCell
        case SettingPickerCell
        
        //Today Extension
        case TodayExtensionCell
        case TodayExtensionKeyValueExtensionCell
        
    }
    
    public func dequeueReusableCellWithCellIdentifier(_ cell: TableViewCellIdentifier, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: cell.rawValue, for: indexPath)
    }
    
}
