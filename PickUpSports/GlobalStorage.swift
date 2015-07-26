//
//  GlobalStorage.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/8/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import MaterialKit

class GlobalStorage:NSObject {
    static var sportHeaderCell: SportHeaderCell!
    static var cityHeaderCell: CityHeaderCell!
    static var currentGame: Game!
    static var currentUser: Person!
    static var sports: [String]!

    static var timeZone = NSTimeZone.localTimeZone().name
    static var errorColor = UIColor(rgba: "#AF0725)")
    static var successColor = UIColor.MKColor.Green
    static var backgroundImage = UIImage(named: "sports")
    
    static var url = "http://localhost:3000/api/v1"
    static var currentAuth = "?user_email=me@example.com&user_token=uz73Hiuwfo1ADQaUsgu1"

}