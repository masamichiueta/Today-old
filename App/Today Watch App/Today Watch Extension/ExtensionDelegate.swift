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
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    func applicationDidBecomeActive() {

    }
    
    func applicationWillResignActive() {

    }
    
}

//MARK: - WCSessionDelegate
extension ExtensionDelegate: WCSessionDelegate {
    
}
