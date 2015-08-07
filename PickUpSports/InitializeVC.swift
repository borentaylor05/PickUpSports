//
//  InitializeVC.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/26/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit

class InitializeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
    //    defaults.clear()
        if let token = defaults.stringForKey("token"){
            if let email = defaults.stringForKey("email"){
                if let id = defaults.stringForKey("user_id"){
                    if let username: AnyObject = defaults.stringForKey("username"){
                            if let cities: AnyObject = defaults.arrayForKey("cities"){
                                if let sports: AnyObject = defaults.arrayForKey("sports"){
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.performSegueWithIdentifier("all_init", sender: self)
                                    }
                                }
                                else{
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.performSegueWithIdentifier("init_to_cities", sender: self)
                                    }
                                }
                            }
                        else{
                            dispatch_async(dispatch_get_main_queue()) {
                                self.performSegueWithIdentifier("init_to_cities", sender: self)
                            }
                        }
                    }
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("init_to_login", sender: self)
                }
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("init_to_login", sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
