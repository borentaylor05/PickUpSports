//
//  SportCell.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/7/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import MaterialKit
import FontAwesome_swift

class SportTableCell: MKTableViewCell {
    
    enum Status{
        case Selected
        case NotSelected
    }
    required init(coder aDecoder: NSCoder) {
        self.status = Status.NotSelected
        super.init(coder: aDecoder)
    }
    
    var status: Status
    
    @IBOutlet weak var subview: CardView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var plus: UILabel!
    
    @IBOutlet weak var citySubview: CardView!
    @IBOutlet weak var cityPlus: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override var layoutMargins: UIEdgeInsets {
        get { return UIEdgeInsetsZero }
        set(newVal) {}
    }
    
    func setMessage(message: String) {
        cellLabel.text = message
    }
    
    func formatCell(text:String, status:Status){
        var cell = self
        var currentIcon:UILabel!
        if let cp = cell.cityPlus{
            cell.plus = cell.cityPlus
            cell.cellLabel = cell.cityLabel
            cell.subview = citySubview
        }
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.plus.font = UIFont.fontAwesomeOfSize(30)
        cell.plus.alpha = 1.0
        
        cell.cellLabel.textColor = UIColor.whiteColor()
        cell.cellLabel.text = text.capitalizedString
        cell.cellLabel.alpha = 1.0
        
        cell.subview.alpha = 0.8
        cell.subview.frame.size.height = cell.frame.size.height - 10
        cell.subview.backgroundColor = UIColor(rgba: "#444444")
        cell.subview.layoutSubviews()
        
        switch status{
        case .Selected:
            cell.rippleLayerColor = UIColor.greenColor()
            cell.plus.text = String.fontAwesomeIconWithName(FontAwesome.Check)
            cell.plus.textColor = UIColor.greenColor()
        case .NotSelected:
            cell.rippleLayerColor = UIColor.whiteColor()
            cell.plus.text = String.fontAwesomeIconWithName(FontAwesome.Plus)
            cell.plus.textColor = UIColor.whiteColor()
        }
       
    }
    
}
