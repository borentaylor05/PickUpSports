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
        println("KNOCK")
    }
    
        
/*** BIOLERPLATE ***/
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
