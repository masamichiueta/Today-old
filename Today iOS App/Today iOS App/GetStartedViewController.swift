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
                startButton.isEnabled = true
            }
        }
    }
    private var iCloudSet: Bool = false {
        didSet {
            if notificationSet && iCloudSet {
                startButton.isEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.isEnabled = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        launchIconCenterYConstraint.isActive = false
        NSLayoutConstraint(item: permissionStackView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: launchIcon, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 30).isActive = true
        launchIconBottomConstraint?.isActive = true
        UIView.animate(withDuration: 1.0,
            delay: 0.0,
            options: UIViewAnimationOptions(),
            animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
                UIView.animate(withDuration: 0.5,
                    animations: {
                        self.permissionStackView.isHidden = false
                        self.permissionStackView.alpha = 1.0
                        self.startButton.isHidden = false
                        self.startButton.alpha = 1.0
                })
        })
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showNotificationPermission(_ sender: AnyObject) {
        NotificationManager.setupLocalNotificationSetting()
        notificationButton.backgroundColor = UIColor.defaultTintColor()
        notificationButton.setTitleColor(UIColor.white(), for: UIControlState())
        notificationButton.isUserInteractionEnabled = false
        notificationSet = true
    }
    
    @IBAction func showiCloudPermission(_ sender: AnyObject) {
        
        let coreDataManager = CoreDataManager.sharedInstance
        
        let alertController = UIAlertController(title: localize("Choose Storage Option"), message: localize("Should documents be stored in iCloud and available on all your devices?"), preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: localize("Local Only"), style: .cancel, handler: { action in
            var setting = Setting()
            setting.iCloudEnabled = false
            setting.ubiquityIdentityToken = nil
            coreDataManager.createTodayMainContext(.local)
            self.iCloudButton.setTitle(localize("Use local storage"), for: UIControlState())
        }))
        
        alertController.addAction(UIAlertAction(title: localize("Use iCloud"), style: .default, handler: { action in
            
            var setting = Setting()
        
            if let currentiCloudToken = FileManager.default().ubiquityIdentityToken {
                let newTokenData = NSKeyedArchiver.archivedData(withRootObject: currentiCloudToken)
                setting.ubiquityIdentityToken = newTokenData
                setting.iCloudEnabled = true
                coreDataManager.createTodayMainContext(.cloud)
            } else {
                let alertController = UIAlertController(title: localize("iCloud is Disabled"), message: localize("Your iCloud account is disabled. Please sign in from setting."), preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: localize("OK"), style: .default, handler: { action in
                    self.iCloudButton.isEnabled = false
                    self.iCloudButton.isUserInteractionEnabled = false
                    self.iCloudButton.setTitle(localize("Please sign in iCloud"), for: UIControlState())
                    self.iCloudButton.borderColor = self.iCloudButton.currentTitleColor
                }))
                self.present(alertController, animated: true, completion: nil)
                setting.ubiquityIdentityToken = nil
                coreDataManager.createTodayMainContext(.local)
            }
        }))
        self.present(alertController, animated: true, completion: { finished in
            self.iCloudButton.backgroundColor = UIColor.defaultTintColor()
            self.iCloudButton.setTitleColor(UIColor.white(), for: UIControlState())
            self.iCloudButton.isUserInteractionEnabled = false
        })
        iCloudSet = true
    }
    
    @IBAction func startToday(_ sender: AnyObject) {
        guard let appDelegate = UIApplication.shared().delegate as? AppDelegate else {
            fatalError("Wrong appdelegate type")
        }
        var setting = Setting()
        setting.firstLaunch = false
        
        let mainStoryboard = UIStoryboard.storyboard(.Main)
        guard let vc = mainStoryboard.instantiateInitialViewController() as? UITabBarController else {
            fatalError("InitialViewController not found")
        }
        
        guard let moc = CoreDataManager.sharedInstance.managedObjectContext else {
            fatalError("ManagedObjectContext not found")
        }
        
        guard let overlayView = appDelegate.window?.snapshotView(afterScreenUpdates: false) else {
            appDelegate.window?.rootViewController = vc
            appDelegate.updateManagedObjectContextInAllViewControllers(moc)
            return
        }
        
        vc.view.addSubview(overlayView)
        appDelegate.window?.rootViewController = vc
        appDelegate.updateManagedObjectContextInAllViewControllers(moc)
        UIView.animate(withDuration: 0.5,
            delay: 0,
            options: .transitionCrossDissolve,
            animations: {
                overlayView.alpha = 0
            },
            completion: { finished in
                overlayView.removeFromSuperview()
        })
    }
}
