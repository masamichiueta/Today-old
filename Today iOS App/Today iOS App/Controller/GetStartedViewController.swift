//
//  GetStartedViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/13.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

final class GetStartedViewController: UIViewController {
    
    @IBOutlet weak var launchIcon: UIImageView!
    @IBOutlet weak var launchIconCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var launchIconCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var permissionStackView: UIStackView!
    @IBOutlet weak var notificationButton: BorderButton!
    @IBOutlet weak var iCloudButton: BorderButton!
    @IBOutlet weak var startButton: BorderButton!
    
    var launchIconBottomConstraint: NSLayoutConstraint?
    
    private var notificationSet: Bool = false {
        didSet {
            if notificationSet && iCloudSet {
                startButton.enabled = true
            }
        }
    }
    private var iCloudSet: Bool = false {
        didSet {
            if notificationSet && iCloudSet {
                startButton.enabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.enabled = false
        
    }
    
    override func viewDidAppear(animated: Bool) {
        launchIconCenterYConstraint.active = false
        NSLayoutConstraint(item: permissionStackView, attribute: NSLayoutAttribute.Top, relatedBy: .Equal, toItem: launchIcon, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 30).active = true
        launchIconBottomConstraint?.active = true
        UIView.animateWithDuration(1.0,
            delay: 0.0,
            options: .CurveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
                UIView.animateWithDuration(0.5,
                    animations: {
                        self.permissionStackView.hidden = false
                        self.permissionStackView.alpha = 1.0
                        self.startButton.hidden = false
                        self.startButton.alpha = 1.0
                })
        })
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showNotificationPermission(sender: AnyObject) {
        NotificationManager.setupLocalNotificationSetting()
        notificationButton.backgroundColor = UIColor.defaultTintColor()
        notificationButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        notificationButton.userInteractionEnabled = false
        notificationSet = true
    }
    
    @IBAction func showiCloudPermission(sender: AnyObject) {
        
        let coreDataManager = CoreDataManager.sharedInstance
        
        let alertController = UIAlertController(title: localize("Choose Storage Option"), message: localize("Should documents be stored in iCloud and available on all your devices?"), preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: localize("Local Only"), style: .Cancel, handler: { action in
            var setting = Setting()
            setting.iCloudEnabled = false
            setting.ubiquityIdentityToken = nil
            coreDataManager.createTodayMainContext(.Local)
            self.iCloudButton.setTitle(localize("Use local storage"), forState: .Normal)
        }))
        
        alertController.addAction(UIAlertAction(title: localize("Use iCloud"), style: .Default, handler: { action in
            
            var setting = Setting()
        
            if let currentiCloudToken = NSFileManager.defaultManager().ubiquityIdentityToken {
                let newTokenData = NSKeyedArchiver.archivedDataWithRootObject(currentiCloudToken)
                setting.ubiquityIdentityToken = newTokenData
                setting.iCloudEnabled = true
                coreDataManager.createTodayMainContext(.Cloud)
            } else {
                let alertController = UIAlertController(title: localize("iCloud is Disabled"), message: localize("Your iCloud account is disabled. Please sign in from setting."), preferredStyle: .Alert)
                
                alertController.addAction(UIAlertAction(title: localize("OK"), style: .Default, handler: { action in
                    self.iCloudButton.enabled = false
                    self.iCloudButton.userInteractionEnabled = false
                    self.iCloudButton.setTitle(localize("Please sign in iCloud"), forState: .Normal)
                    self.iCloudButton.borderColor = self.iCloudButton.currentTitleColor
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                setting.ubiquityIdentityToken = nil
                coreDataManager.createTodayMainContext(.Local)
            }
        }))
        self.presentViewController(alertController, animated: true, completion: { finished in
            self.iCloudButton.backgroundColor = UIColor.defaultTintColor()
            self.iCloudButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.iCloudButton.userInteractionEnabled = false
        })
        iCloudSet = true
    }
    
    @IBAction func startToday(sender: AnyObject) {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            fatalError("Wrong appdelegate type")
        }
        var setting = Setting()
        setting.firstLaunch = false
        
        let mainStoryboard = UIStoryboard.storyboard(.Main)
        guard let vc = mainStoryboard.instantiateInitialViewController() as? UITabBarController else {
            fatalError("InitialViewController not found")
        }
        
        guard let overlayView = appDelegate.window?.snapshotViewAfterScreenUpdates(false) else {
            appDelegate.window?.rootViewController = vc
            appDelegate.updateManagedObjectContextInAllViewControllers()
            return
        }
        vc.view.addSubview(overlayView)
        appDelegate.window?.rootViewController = vc
        appDelegate.updateManagedObjectContextInAllViewControllers()
        UIView.animateWithDuration(0.5,
            delay: 0,
            options: .TransitionCrossDissolve,
            animations: {
                overlayView.alpha = 0
            },
            completion: { finished in
                overlayView.removeFromSuperview()
        })
    }
}
