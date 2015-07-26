//
//  CommentCell.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/10/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var comment: Comment!

    override func awakeFromNib() {
        super.awakeFromNib()
        bodyLabel.numberOfLines = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
