//
//  SportCell.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/7/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import MaterialKit

class SportCell: MKTableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellIV: UIImageView!

    override var layoutMargins: UIEdgeInsets {
        get { return UIEdgeInsetsZero }
        set(newVal) {}
    }
    
    func setMessage(message: String) {
        cellLabel.text = message
    }
    func setMyImage(name: String){
        cellIV.image = UIImage(named: name)
    }

}
