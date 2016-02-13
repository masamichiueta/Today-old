//
//  GetStartedViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/13.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {
    
    @IBOutlet weak var launchIcon: UIImageView!
    @IBOutlet weak var launchIconCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var launchIconCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var permissionStackView: UIStackView!
    
    @IBOutlet weak var notificationButton: BorderButton!
    @IBOutlet weak var iCloudButton: BorderButton!
    @IBOutlet weak var startButton: BorderButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
