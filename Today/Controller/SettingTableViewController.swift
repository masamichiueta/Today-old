//
//  SettingTableViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/07.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        default:
            break
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            guard let cell = tableView.dequeueReusableCellWithIdentifier("PickerCell", forIndexPath: indexPath) as? TodayPickerTableViewCell else {
                fatalError("Wrong cell type")
            }
            return cell
        default:
            break
        }
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        return cell
    }
}
