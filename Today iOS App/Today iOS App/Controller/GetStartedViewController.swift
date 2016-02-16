//
//  GetStartedViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/13.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

class GetStartedViewController: UIViewController {
    
    @IBOutlet weak var launchIcon: UIImageView!
    @IBOutlet weak var launchIconCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var launchIconCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var permissionStackView: UIStackView!
    @IBOutlet weak var notificationButton: BorderButton!
    @IBOutlet weak var iCloudButton: BorderButton!
    @IBOutlet weak var startButton: BorderButton!
    
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
        NSLayoutConstraint(item: launchIcon, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 0.3, constant: 0).active = true
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
        
        if let currentiCloudToken = NSFileManager.defaultManager().ubiquityIdentityToken {
            let alertController = UIAlertController(title: "Choose Storage Option", message: "Should documents be stored in iCloud and available on all your devices?", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Local Only", style: .Cancel, handler: { action in
                self.iCloudButton.setTitle("Use local storage", forState: .Normal)
            }))
            alertController.addAction(UIAlertAction(title: "Use iCloud", style: .Default, handler: { action in
                let newTokenData = NSKeyedArchiver.archivedDataWithRootObject(currentiCloudToken)
                var setting = Setting()
                setting.ubiquityIdentityToken = newTokenData
                setting.iCloudEnabled = true
            }))
            self.presentViewController(alertController, animated: true, completion: { finished in
                self.iCloudButton.backgroundColor = UIColor.defaultTintColor()
                self.iCloudButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.iCloudButton.userInteractionEnabled = false
            })
        } else {
            let alertController = UIAlertController(title: "iCloud is Disabled", message: "Your iCloud account is disabled. Please sign in from setting.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                self.iCloudButton.enabled = false
                self.iCloudButton.userInteractionEnabled = false
                self.iCloudButton.setTitle("Please sign in iCloud", forState: .Normal)
                self.iCloudButton.borderColor = self.iCloudButton.currentTitleColor
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
            var setting = Setting()
            setting.ubiquityIdentityToken = nil
        }
        iCloudSet = true
    }
    
    @IBAction func startToday(sender: AnyObject) {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            fatalError("Wrong appdelegate type")
        }
        var setting = Setting()
        setting.firstLaunch = false
        
        let storageType: StorageType
        if setting.iCloudEnabled {
            appDelegate.registerForiCloudNotifications()
            storageType = .ICloud
        } else {
            storageType = .Local
        }
        appDelegate.managedObjectContext = createTodayMainContext(storageType)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = mainStoryboard.instantiateInitialViewController() else {
            fatalError("InitialViewController not found")
        }
        guard let managedObjectContextSettable = vc as? ManagedObjectContextSettable else {
            fatalError("Wrong view controller type")
        }
        managedObjectContextSettable.managedObjectContext = appDelegate.managedObjectContext
        
        guard let overlayView = appDelegate.window?.snapshotViewAfterScreenUpdates(false) else {
            appDelegate.window?.rootViewController = vc
            return
        }
        vc.view.addSubview(overlayView)
        appDelegate.window?.rootViewController = vc
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
