//
//  InterfaceController.swift
//  TodayWatch Extension
//
//  Created by UetaMasamichi on 2016/01/20.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session: WCSession!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
//    @IBAction func addToday() {
//        
//        if session.reachable {
//            session.sendMessage(["score": 10],
//                replyHandler: {
//                    (content: [String: AnyObject]) -> Void in
//                    print("Our counterpart sent something back. This is optional")
//                },
//                errorHandler: {
//                    (error) -> Void in
//                    print("We got an error from our paired device : " + error.domain)
//            })
//        }
//        
//    }
}
