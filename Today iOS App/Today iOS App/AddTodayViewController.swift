//
//  AddTodayViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/28.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

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
            scoreLabel.layer.add(animation, forKey: nil)
            self.scoreLabel.text = "\(self.score)"
            let toStrokeColor = Today.type(score).color()
            scoreLabel.textColor = toStrokeColor
            iconImageView.tintColor = toStrokeColor
            UIView.transition(with: iconImageView,
                duration: scoreCircleView.animationDuration,
                options: UIViewAnimationOptions.transitionCrossDissolve,
                animations: { [unowned self] in
                    self.iconImageView.image = Today.type(self.score).icon(.Fourty)
                    self.view.layoutIfNeeded()
                },
                completion: { finished in
                    
            })
        }
    }
    
    private let thinProgressBorderGroup: [Device] = [.iPhone4, .iPhone4s, .simulator(.iPhone4), .simulator(.iPhone4s)]
    private let device = Device()
    private let thinProgressBorderWidth: CGFloat = 5.0
    private let defaultProgressBorderWidth: CGFloat = 10.0
    private let smallScoreFont = UIFont.systemFont(ofSize: 50, weight: UIFontWeightThin)
    private let defaultScoreFont = UIFont.systemFont(ofSize: 100, weight: UIFontWeightThin)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressBorderWidth()
        scoreLabel.textColor = scoreCircleView.progressCircleColor
        iconImageView.image = Today.type(score).icon(.Fourty)
        iconImageView.tintColor = scoreCircleView.progressCircleColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let compactHeightCollection = UITraitCollection(verticalSizeClass: .compact)
        
        if traitCollection.containsTraits(in: compactHeightCollection) || device.isOneOf(thinProgressBorderGroup) {
            scoreCircleView.progressBorderWidth = thinProgressBorderWidth
            scoreLabel.font = smallScoreFont
        } else {
            scoreCircleView.progressBorderWidth = defaultProgressBorderWidth
            scoreLabel.font = defaultScoreFont
        }
    }
    
    private func setupProgressBorderWidth() {
        let compactHeightCollection = UITraitCollection(verticalSizeClass: .compact)
        if traitCollection.containsTraits(in: compactHeightCollection) || device.isOneOf(thinProgressBorderGroup) {
            scoreCircleView.progressBorderWidth = thinProgressBorderWidth
            scoreLabel.font = defaultScoreFont
        }
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension AddTodayViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Today.masterScores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Today.masterScores[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        score = Today.masterScores[row]
    }
}
