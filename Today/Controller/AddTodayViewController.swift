//
//  AddTodayViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/28.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayModel
import LTMorphingLabel

class AddTodayViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var scoreLabel: LTMorphingLabel!
    @IBOutlet weak var ringProgressView: MKRingProgressView!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.morphingEffect = .Evaporate
        score = Today.masterScores[0]
    }
    
    override func viewDidAppear(animated: Bool) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        ringProgressView.progress = 1.0
        CATransaction.commit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddTodayViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Today.masterScores.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Today.masterScores[row])"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        score = Today.masterScores[row]
    }
}