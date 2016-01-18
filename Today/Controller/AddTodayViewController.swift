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
    @IBOutlet weak var iconImageView: UIImageView!
    
    var score: Int =  Today.maxScore {
        didSet {
            scoreCircleView.score = score
            scoreLabel.morphingDuration = Float(scoreCircleView.animationDuration + 0.15)
            scoreLabel.text = "\(score)"
            let toStrokeColor = Today.type(score).color()
            scoreLabel.textColor = toStrokeColor
            iconImageView.tintColor = toStrokeColor
            UIView.transitionWithView(iconImageView,
                duration: scoreCircleView.animationDuration,
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: { [unowned self] in
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
        iconImageView.image = Today.type(score).icon("40")
        iconImageView.tintColor = scoreCircleView.progressCircleColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
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
