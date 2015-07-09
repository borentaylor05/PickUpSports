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
    
    func formatSport(cell: SportTableCell, text:String) -> SportTableCell{
        
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.rippleLayerColor = UIColor.greenColor()
        
        cell.plus.font = UIFont.fontAwesomeOfSize(30)
        cell.plus.text = String.fontAwesomeIconWithName(FontAwesome.Plus)
        cell.plus.textColor = UIColor.whiteColor()
        cell.plus.alpha = 1.0
        
        cell.cellLabel.textColor = UIColor.whiteColor()
        cell.cellLabel.text = text
        cell.cellLabel.alpha = 1.0
        
        cell.subview.alpha = 0.8
        cell.subview.frame.size.height = cell.frame.size.height - 10
        cell.subview.backgroundColor = UIColor(rgba: "#444444")
        cell.subview.layoutSubviews()
        return cell
    }
    
    func formatCity(cell: SportTableCell, text:String) -> SportTableCell{
        
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.rippleLayerColor = UIColor.greenColor()
        
        cell.cityPlus.font = UIFont.fontAwesomeOfSize(30)
        cell.cityPlus.text = String.fontAwesomeIconWithName(FontAwesome.Plus)
        cell.cityPlus.textColor = UIColor.whiteColor()
        cell.cityPlus.alpha = 1.0
        
        cell.cityLabel.textColor = UIColor.whiteColor()
        cell.cityLabel.text = text
        cell.cityLabel.alpha = 1.0
        
        cell.citySubview.alpha = 0.8
        cell.citySubview.frame.size.height = cell.frame.size.height - 1
        cell.citySubview.backgroundColor = UIColor(rgba: "#444444")
        cell.citySubview.layoutSubviews()
        return cell
    }
    
}
