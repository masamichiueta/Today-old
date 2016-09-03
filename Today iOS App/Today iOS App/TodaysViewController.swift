//
//  TodaysViewController.swift
//  Today
//
//  Created by UetaMasamichi on 9/3/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit
import CoreData

class TodaysViewController: UIViewController {
    
    var moc: NSManagedObjectContext!

    @IBOutlet weak var calendarView: RSDFDatePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moc = CoreDataManager.shared.persistentContainer.viewContext
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelToTodaysViewController(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func saveAddTodayViewController(_ segue: UIStoryboardSegue) {
        guard let vc = segue.source as? AddTodayViewController else {
            fatalError("Wrong view controller type")
        }
        
        let now = Date()
        
        if Today.created(moc, forDate: now) {
            showAddAlert(nil)
            return
        }
        
        moc.perform {
            //Create today
            let _ = Today.insertIntoContext(self.moc, score: Int64(vc.score), date: now)
            let _ = Streak.updateOrCreateCurrentStreak(self.moc, date: now)
        }
    }
    
    @IBAction func showAddTodayViewController(_ sender: AnyObject) {
        if Today.created(moc, forDate: Date()) {
            showAddAlert(nil)
        } else {
            performSegue(withIdentifier: "showAddTodayViewController", sender: self)
        }
    }
    
    fileprivate func showAddAlert(_ completion: (() -> Void)?) {
        let alert = UIAlertController(title: localize("Wow!"), message: localize("Everything is OK. \nYou have already created Today."), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("OK"), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TodaysViewController: RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource {
    func datePickerView(_ view: RSDFDatePickerView, shouldHighlight date: Date) -> Bool {
        return true
    }
    
    func datePickerView(_ view: RSDFDatePickerView, shouldSelect date: Date) -> Bool {
        return true
    }
    
    func datePickerView(_ view: RSDFDatePickerView, didSelect date: Date) {
        print("select date")
    }
    
    
}
