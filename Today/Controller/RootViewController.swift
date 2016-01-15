//
//  RootViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData

class RootViewController: UIViewController, ManagedObjectContextSettable {
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        for child in segue.destinationViewController.childViewControllers {
            switch child {
            case is UINavigationController:
                let nc = child as! UINavigationController
                guard let vc = nc.viewControllers.first as? ManagedObjectContextSettable else {
                    fatalError("expected managed object settable")
                }
                vc.managedObjectContext = managedObjectContext
            default:
                guard let vc = child as? ManagedObjectContextSettable else {
                    fatalError("expected managed object settable")
                }
                vc.managedObjectContext = managedObjectContext
            }
        }
        
    }
    
}
