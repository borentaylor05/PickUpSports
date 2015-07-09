//
//  SportHeaderCell.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/8/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import MaterialKit

class SportHeaderCell: MKTableViewCell {

    @IBOutlet weak var headerSubview: CardView!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
