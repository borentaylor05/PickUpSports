//
//  SecondViewController.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/6/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Blah", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

