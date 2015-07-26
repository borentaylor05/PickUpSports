//
//  CityHeaderCell.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/8/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit

class CityHeaderCell: UITableViewCell {

    @IBOutlet weak var chLabel: UILabel!
    @IBOutlet weak var chSubview: CardView!
    
    func headerTapped(){
        var body = "Select all the cities in your area.  You will be alerted when someone starts a game in these cities for all sports you select on the next screen."
        var settings = Modal.Settings()
        settings.backgroundColor = .whiteColor()
        settings.shadowType = .Curl
        settings.shadowRadius = CGFloat(5)
        settings.shadowOffset = CGSize(width: 0, height: -3)
        settings.overlayBlurStyle = .Dark
        
        Modal(title: "You're Almost Ready to Go!", body: body, status: .Warning, settings: settings).show()
    }
    
        
/*** BIOLERPLATE ***/
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
