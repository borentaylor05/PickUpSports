//
//  Game.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/9/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Game {
    var title:String!
    var location: String!
    var city: City!
    var datetime: NSDate!
    var sport: Sport!
    var players: [Person]?
    var playersNeeded: Int!
    var createdBy: String!
    var id: Int!
    var joined: Bool
    init(title: String, location: String, city: City, datetime: NSDate, sport: Sport, playersNeeded:Int, createdBy:String, id: Int, joined:Bool){
        self.title = title
        self.location = location
        self.city = city
        self.datetime = datetime
        self.sport = sport
        self.createdBy = createdBy
        self.playersNeeded = playersNeeded
        self.id = id
        self.joined = joined
    }
    
    static func create(game:[String:String], callback:(JSON?) -> Void){
        Alamofire.request(.POST, Util.formatUrl("/games"), parameters: game).responseJSON{
            (req, resp, json, err) in
            let resp: JSON? = JSON(json!)
            callback(resp!)
        }
    }
}






