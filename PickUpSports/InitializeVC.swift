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
        if let token = defaults.stringForKey("token"){
            if let email = defaults.stringForKey("email"){
                if let cities: AnyObject = defaults.objectForKey("cities"){
                    if let sports: AnyObject = defaults.objectForKey("sports"){
                        self.performSegueWithIdentifier("all_init", sender: self)
                    }
                    else{
                        self.performSegueWithIdentifier("init_to_sports", sender: self)
                    }
                }
                else{
                    self.performSegueWithIdentifier("init_to_cities", sender: self)
                }
            }
            else{
                self.performSegueWithIdentifier("init_to_login", sender: self)
            }
        }
        else{
            self.performSegueWithIdentifier("init_to_login", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
