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
    
    @IBOutlet weak var scoreCircleView: TodayScoreCircleView!
    
    @IBOutlet weak var scoreLabel: LTMorphingLabel!
    
    @IBOutlet weak var wordLabel: LTMorphingLabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    var score: Int =  Today.maxScore {
        didSet {
            scoreCircleView.score = score
            scoreLabel.morphingDuration = Float(scoreCircleView.animationDuration + 0.15)
            wordLabel.morphingDuration = Float(scoreCircleView.animationDuration + 0.15)
            scoreLabel.text = "\(score)"
            wordLabel.text = Today.type(score).rawValue
            let toStrokeColor = Today.type(score).color()
            self.scoreLabel.textColor = toStrokeColor
            self.wordLabel.textColor = toStrokeColor
            UIView.transitionWithView(iconImageView,
                duration: scoreCircleView.animationDuration,
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: { [unowned self] in
                    self.iconImageView.tintColor = toStrokeColor
                    self.iconImageView.image = Today.type(self.score).icon("40")
                    self.view.layoutIfNeeded()
                },
                completion: { finished in
                    
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.morphingEffect = .Evaporate
        scoreLabel.textColor = scoreCircleView.progressCircleColor
        wordLabel.morphingEffect = .Evaporate
        wordLabel.textColor = scoreCircleView.progressCircleColor
        
        iconImageView.image = Today.type(score).icon("40")
        iconImageView.tintColor = scoreCircleView.progressCircleColor
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