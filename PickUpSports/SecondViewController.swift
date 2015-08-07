//
//  SecondViewController.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/6/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import MaterialKit
import FontAwesome_swift

class SecondViewController: UIViewController {
    
    @IBOutlet weak var changeSportsButton: MKButton!
    @IBOutlet weak var changeCitiesButton: MKButton!
    @IBOutlet weak var sportsIcon: UILabel!
    @IBOutlet weak var citiesIcon: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sportsIcon.makeIconLabel(FontAwesome.Trophy)
        citiesIcon.makeIconLabel(FontAwesome.Building)
        self.navigationItem.title = "Change Settings"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logout"{
            let defaults = NSUserDefaults()
            defaults.clear()
        }
        else if segue.identifier == "edit_sports"{
            let destination = segue.destinationViewController as! SportsTableViewController
            destination.editingSports = true
        }
        else if segue.identifier == "edit_cities"{
            let destination = segue.destinationViewController as! CityVC
            destination.editingCities = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

