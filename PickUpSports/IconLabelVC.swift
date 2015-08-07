//
//  IconLabelVC.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/31/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import FontAwesome_swift

class IconLabelVC: UIViewController {
    // Example Implementation
    //        var specialButton = self.storyboard?.instantiateViewControllerWithIdentifier("IconLabelVC") as! IconLabelVC
    //        specialButton.view.frame = CGRectMake(0, 380, specialButton.view.frame.size.width,    specialButton.view.frame.size.height)
    //        specialButton.setBackgroundColor(UIColor.MKColor.BlueGrey)
    //        specialButton.setLabelWidth(200)
    //        specialButton.setIcon(FontAwesome.Anchor)
    //        self.view.addSubview(specialButton.view)
    
    var x:CGFloat = 0
    var y:CGFloat = 0
    var width:CGFloat = 260
    var height:CGFloat = 45

    @IBOutlet weak var labelButton: UIButton!
    @IBOutlet var background: UIView!
    @IBOutlet weak var iconLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRectMake(x, y, width, height)
        iconLabel.font = UIFont.fontAwesomeOfSize(18)
        iconLabel.layer.addBorder(UIRectEdge.Right, color: UIColor(rgba: "#AAAAAA"), thickness: 1)
    }
    
    func setLabelWidth(width:CGFloat){
        self.width = width
        self.view.frame = CGRectMake(x, y, self.width, height)
    }

    func setLabelHeight(height:CGFloat){
        self.height = height
        self.view.frame = CGRectMake(x, y, width, self.height)
    }
    
    func setBackgroundColor(color:UIColor){
        self.background.backgroundColor = color
    }
    
    func setIcon(icon:FontAwesome){
        iconLabel.text = String.fontAwesomeIconWithName(icon)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
