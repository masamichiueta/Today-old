//
//  AddTodayViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/28.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit
import DeviceKit

final class AddTodayViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var scoreCircleView: ScoreCircleView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var score: Int =  Today.maxMasterScore {
        didSet {
            scoreCircleView.score = score
            let animation = CATransition()
            animation.type = kCATransitionFade
            animation.duration = scoreCircleView.animationDuration
            scoreLabel.layer.addAnimation(animation, forKey: nil)
            self.scoreLabel.text = "\(self.score)"
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
    
    private let thinProgressBorderGroup: [Device] = [.iPhone4, .iPhone4s, .Simulator(.iPhone4), .Simulator(.iPhone4s)]
    private let device = Device()
    private let thinProgressBorderWidth: CGFloat = 5.0
    private let defaultProgressBorderWidth: CGFloat = 10.0
    private let smallScoreFont = UIFont.systemFontOfSize(50, weight: UIFontWeightThin)
    private let defaultScoreFont = UIFont.systemFontOfSize(100, weight: UIFontWeightThin)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressBorderWidth()
        scoreLabel.textColor = scoreCircleView.progressCircleColor
        iconImageView.image = Today.type(score).icon("40")
        iconImageView.tintColor = scoreCircleView.progressCircleColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        let compactHeightCollection = UITraitCollection(verticalSizeClass: .Compact)
        
        if traitCollection.containsTraitsInCollection(compactHeightCollection) || device.isOneOf(thinProgressBorderGroup) {
            scoreCircleView.progressBorderWidth = thinProgressBorderWidth
            scoreLabel.font = smallScoreFont
        } else {
            scoreCircleView.progressBorderWidth = defaultProgressBorderWidth
            scoreLabel.font = defaultScoreFont
        }
    }
    
    private func setupProgressBorderWidth() {
        let compactHeightCollection = UITraitCollection(verticalSizeClass: .Compact)
        if traitCollection.containsTraitsInCollection(compactHeightCollection) || device.isOneOf(thinProgressBorderGroup) {
            scoreCircleView.progressBorderWidth = thinProgressBorderWidth
            scoreLabel.font = defaultScoreFont
        }
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
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
