//
//  ExtensionDelegate.swift
//  TodayWatch Extension
//
//  Created by UetaMasamichi on 2016/01/20.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import WatchKit
import WatchConnectivity
import TodayWatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    private var session: WCSession!
    
    func applicationDidFinishLaunching() {
        
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    
    func applicationDidBecomeActive() {

    }
    
    func applicationWillResignActive() {

    }
    
}

//MARK: - WCSessionDelegate
extension ExtensionDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: NSError?) {
        
    }
}
