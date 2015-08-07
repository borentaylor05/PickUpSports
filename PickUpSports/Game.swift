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
    var createdBy: String?
    var id: Int?
    var joined: Bool?
    init(title: String, location: String, city: City, datetime: NSDate, sport: Sport, createdBy:String, id: Int, joined:Bool){
        self.title = title
        self.location = location
        self.city = city
        self.datetime = datetime
        self.sport = sport
        self.createdBy = createdBy
        self.id = id
        self.joined = joined
    }
    init(title: String, location: String, city: City, datetime: NSDate, sport: Sport, createdBy:String){
        self.title = title
        self.location = location
        self.city = city
        self.datetime = datetime
        self.sport = sport
        self.createdBy = createdBy
    }
    
    func create(callback:ApiResponse){
        HTTP.post("/games", params: self.toDictionaryParams()) { (response) in
            callback(response)
        }
    }
    
    func join(callback:ApiResponse){
        HTTP.post("/games/\(self.id!)/join", params: nil){ (response) in
            callback(response)
        }
    }
    
    func toDictionaryParams() -> [String:String]{
        return ["title": self.title,
                "location": self.location,
                "city": self.city.toString(),
                "time": self.datetime.toRailsStringDate(),
                "sport": self.sport.name
                ]
    }
    
    static func jsonToGame(game:JSON) -> Game{
        return Game(title: game["title"].string!,
            location: game["location"].string!,
            city: City(name: game["city"]["name"].string!, state: game["city"]["state"].string!),
            datetime: game["time"].string!.rails_date(),
            sport: Sport(name: game["sport"]["name"].string!),
            createdBy: game["owner"].string!,
            id: game["id"].int!,
            joined: game["joined"].bool!
        )
    }
}






