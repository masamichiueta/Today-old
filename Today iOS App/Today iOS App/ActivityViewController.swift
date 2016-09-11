//
//  ActivityViewController.swift
//  Today
//
//  Created by UetaMasamichi on 9/10/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData
import TodayKit

class ActivityViewController: UIViewController {
    
    @IBOutlet weak var graphView: ScrollableGraphView!
    
    @IBOutlet weak var longestStreakLabel: UILabel!
    @IBOutlet weak var longestStreakDateLabel: UILabel!
    
    @IBOutlet weak var currentStreakLabel: UILabel!
    @IBOutlet weak var currentStreakDateLabel: UILabel!
    
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    var moc: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moc = CoreDataManager.shared.persistentContainer.viewContext
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let color = Today.lastColor(moc)
        self.updateTintColor(color)
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadData() {
        configureGraphView()
        
        if let longestStreak = Streak.longestStreak(moc) {
            longestStreakLabel.text = "\(Int(longestStreak.streakNumber))"
            longestStreakDateLabel.text = "\(dateFormatter.string(from: longestStreak.from)) - \(dateFormatter.string(from: longestStreak.to))"
        } else {
            longestStreakLabel.text = "0"
            longestStreakDateLabel.text = ""
        }
        
        if let currentStreak = Streak.currentStreak(moc) {
            currentStreakLabel.text = "\(Int(currentStreak.streakNumber))"
            currentStreakDateLabel.text = "\(dateFormatter.string(from: currentStreak.from)) - \(dateFormatter.string(from: currentStreak.to))"
        } else {
            currentStreakLabel.text = "0"
            currentStreakDateLabel.text = ""
        }
    }
    
    private func configureGraphView() {
        self.graphView.backgroundFillColor = UIColor.applicationColor(type: .darkViewBackground)
        self.graphView.lineWidth = 1
        self.graphView.lineColor = UIColor.white
        self.graphView.lineStyle = .smooth
        self.graphView.dataPointFillColor = UIColor.white
        self.graphView.shouldAnimateOnStartup = false
        self.graphView.shouldAnimateOnAdapt = false
        self.graphView.dataPointSize = 3
        self.graphView.rangeMin = 0
        self.graphView.rangeMax = 10
        self.graphView.shouldAutomaticallyDetectRange = false
        self.graphView.referenceLineColor = UIColor.applicationColor(type: .darkSeparator)
        self.graphView.numberOfIntermediateReferenceLines = 1
        self.graphView.referenceLineLabelColor = UIColor.applicationColor(type: .darkDetailText)
        self.graphView.dataPointLabelColor = UIColor.applicationColor(type: .darkDetailText)
        self.graphView.topMargin = 24
        self.graphView.bottomMargin = 24
        self.graphView.direction = .rightToLeft
        self.graphView.contentOffset = CGPoint(x: self.graphView.contentSize.width - self.graphView.bounds.width, y: 0)
        
        let now = Date()
        var component = Calendar.current.dateComponents([.year, .month, .day], from: now)
        component.year = component.year! - 1
        let yearAgo = Calendar.current.date(from: component)!
        
        let todays = Today.todays(moc, from: yearAgo, to: now)
        
        var labels: [String] = []
        var data: [Double] = []
        var start = yearAgo
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        while start.compare(now) != .orderedDescending {
            
            let today = todays.filter { Calendar.current.isDate($0.date, inSameDayAs: start) }
            if today.count == 0 {
                data.append(0)
            } else {
                data.append(Double(today[0].score))
            }
            
            labels.append(formatter.string(from: start))
            start = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        }
        
        if Today.count(moc) != 0 {
            self.graphView.shouldFill = true
            self.graphView.fillType = .gradient
            self.graphView.fillGradientType = .linear
            self.graphView.lineColor = Today.lastColor(moc)
            self.graphView.fillGradientStartColor = Today.lastColor(moc)
            self.graphView.fillGradientEndColor = UIColor.applicationColor(type: .darkViewBackground)
            self.graphView.dataPointLabelColor = UIColor.white
        }
        
        self.graphView.setData(data, withLabels: labels)

    }
    
    @IBAction func doneSettingTableViewController(_ segue: UIStoryboardSegue) {
        
    }
    
    
}
