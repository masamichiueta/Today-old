//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by UetaMasamichi on 2016/01/20.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit
import NotificationCenter

final class TodayExtensionViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let tableViewRowHeight: CGFloat = 44.0
    fileprivate let rowNum = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else {
            self.preferredContentSize = CGSize(width: tableView.frame.width, height: tableViewRowHeight * 4)
        }
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableViewRowHeight
    }
    
}

extension TodayExtensionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sharedData = AppGroupSharedData.shared
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodayExtensionCell", for: indexPath) as? TodayExtensionTodayTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.configureForObject(sharedData.todayScore)
            //For tap bug
            cell.backgroundView = UILabel()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodayExtensionKeyValueExtensionCell", for: indexPath)
            cell.textLabel?.text = localize("Total")
            cell.detailTextLabel?.text = "\(sharedData.total) " + localize("days")
            //For tap bug
            cell.backgroundView = UILabel()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodayExtensionKeyValueExtensionCell", for: indexPath)
            cell.textLabel?.text = localize("Longest streak")
            cell.detailTextLabel?.text = "\(sharedData.longestStreak) " + localize("days")
            //For tap bug
            cell.backgroundView = UILabel()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodayExtensionKeyValueExtensionCell", for: indexPath)
            cell.textLabel?.text = localize("Current streak")
            cell.detailTextLabel?.text = "\(sharedData.currentStreak) " + localize("days")
            //For tap bug
            cell.backgroundView = UILabel()
            return cell
        default:
            fatalError("Wront cell number")
        }
        
        //dummy
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: appGroupURLScheme + "://") else {
            return
        }
        extensionContext?.open(url,
            completionHandler: nil)
    }

}
