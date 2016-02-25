//
//  AddTodayInterfaceController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/21.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation
import TodayWatchKit

protocol AddTodayInterfaceControllerDelegate: class {
    func todayDidAdd(score: Int)
}

final class AddTodayInterfaceController: WKInterfaceController {
    
    @IBOutlet var scorePicker: WKInterfacePicker!
    
    private var session: WCSession!
    private var score: Int = Today.maxMasterScore
    weak var delegate: ScoreInterfaceController?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        delegate = context as? ScoreInterfaceController
        
        let pickerItems: [WKPickerItem] = Today.masterScores.map {
            let pickerItem = WKPickerItem()
            
            let watchSize = getWatchSize()
            
            switch watchSize {
            case .ThirtyEight:
                pickerItem.contentImage = WKImage(imageName: "score_select_circle_38_\($0).png")
            case .FourtyTwo:
                pickerItem.contentImage = WKImage(imageName: "score_select_circle_42_\($0).png")
            }
            
            return pickerItem
        }
        
        scorePicker.setItems(pickerItems)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func addToday() {
        if session.reachable {
            session.sendMessage([watchConnectivityActionTypeKey: WatchConnectivityActionType.AddToday.rawValue, WatchConnectivityContentType.Score.rawValue: score],
                replyHandler: {
                    (content: [String: AnyObject]) -> Void in
                    self.delegate?.todayDidAdd(self.score)
                    self.dismissController()
                },
                errorHandler: {
                    (error) -> Void in
                    self.dismissController()
            })
        } else {
            self.dismissController()
        }
        
    }
    
    @IBAction func pickerItemDidChange(value: Int) {
        score = Today.masterScores[value]
    }
}

//MARK: - WCSessionDelegate
extension AddTodayInterfaceController: WCSessionDelegate {
    
}
