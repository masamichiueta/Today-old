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
    
    var graphView: ScrollableGraphView!
    var graphConstraints: [NSLayoutConstraint] = []
    var contentOffset: CGPoint?
    
    @IBOutlet weak var graphPlaceholderView: UIView!
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let color = Today.lastColor(moc)
        self.updateTintColor(color)
        self.reloadData()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func reloadData() {
        
        if self.graphPlaceholderView.subviews.count == 0 {
            KVNProgress.show(withStatus: localize("Loading Data"))
            self.graphView = ScrollableGraphView(frame: self.graphPlaceholderView.bounds)
        }
        
        self.configureGraphView()
        
        DispatchQueue.global(qos: .default).async {
            
            let (labels, data) = self.loadData()
            
            DispatchQueue.main.async {
                
                if self.graphPlaceholderView.subviews.count == 0 {
                    
                    self.graphPlaceholderView.addSubview(self.graphView)
                    
                    let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: .top, relatedBy: .equal, toItem: self.graphPlaceholderView, attribute: .top, multiplier: 1, constant: 0)
                    let leadingConstraint = NSLayoutConstraint(item: self.graphView, attribute: .leading, relatedBy: .equal, toItem: self.graphPlaceholderView, attribute: .leading, multiplier: 1, constant: 0)
                    let trailingConstraint = NSLayoutConstraint(item: self.graphView, attribute: .trailing, relatedBy: .equal, toItem: self.graphPlaceholderView, attribute: .trailing, multiplier: 1, constant: 0)
                    let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: .bottom, relatedBy: .equal, toItem: self.graphPlaceholderView, attribute: .bottom, multiplier: 1, constant: 0)
                    self.graphConstraints.append(topConstraint)
                    self.graphConstraints.append(leadingConstraint)
                    self.graphConstraints.append(trailingConstraint)
                    self.graphConstraints.append(bottomConstraint)
                    self.view.addConstraints(self.graphConstraints)
                    
                    self.graphView.setData(data, withLabels: labels)
                    KVNProgress.dismiss()
                } else {
                    let currentOffset = self.graphView.contentOffset
                    self.graphView.setData(data, withLabels: labels)
                    self.graphView.contentOffset = currentOffset
                }
            }
        }
        
        
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
        
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        self.graphView.backgroundFillColor = UIColor.white
        self.graphView.fillType = .solid
        self.graphView.fillColor = UIColor.white
        self.graphView.lineWidth = 1
        self.graphView.lineColor = UIColor.darkGray
        self.graphView.lineStyle = .smooth
        self.graphView.dataPointFillColor = UIColor.darkGray
        self.graphView.shouldAnimateOnStartup = false
        self.graphView.shouldAnimateOnAdapt = false
        self.graphView.dataPointSize = 3
        self.graphView.rangeMin = 0
        self.graphView.rangeMax = 10
        self.graphView.shouldAutomaticallyDetectRange = false
        self.graphView.referenceLineColor = UIColor.lightGray
        self.graphView.numberOfIntermediateReferenceLines = 1
        self.graphView.referenceLineLabelColor = UIColor.darkGray
        self.graphView.dataPointLabelColor = UIColor.darkGray
        self.graphView.topMargin = 24
        self.graphView.bottomMargin = 24
        self.graphView.direction = .rightToLeft
        
        if Today.count(self.moc) != 0 {
            let lastColor = Today.lastColor(self.moc)
            self.graphView.backgroundFillColor = lastColor
            self.graphView.shouldFill = true
            self.graphView.fillType = .gradient
            self.graphView.fillGradientType = .linear
            self.graphView.lineColor = UIColor.white
            self.graphView.fillGradientStartColor = UIColor.white
            self.graphView.fillGradientEndColor = lastColor
            self.graphView.dataPointLabelColor = UIColor.white
            self.graphView.dataPointFillColor = UIColor.white
            self.graphView.referenceLineColor = UIColor.white
            self.graphView.referenceLineLabelColor = UIColor.white
            
        }

    }
    
    private func loadData() -> (labels: [String], data: [Double]) {
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
        
        return (labels: labels, data: data)
    }
    
    @IBAction func doneSettingTableViewController(_ segue: UIStoryboardSegue) {
        
    }
    
    
}
