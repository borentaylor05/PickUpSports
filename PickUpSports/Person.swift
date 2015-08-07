//
//  Person.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/10/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import Foundation
import SwiftyJSON

class Person {
    var username: String!
    var email: String!
    var token: String!
    var id: Int!
    var cities: [String]?
    var sports: [String]?
    var games = [Game]()
    init(username:String){
        self.username = username
    }
    init(username:String, id:Int, email:String, token:String){
        self.username = username
        self.id = id
        self.token = token
        self.email = email
    }
    init(username:String, id:Int, email:String){
        self.username = username
        self.id = id
        self.email = email
    }
    
    func setCities(){
        let defaults = NSUserDefaults()
        if let myCities: [AnyObject] = defaults.arrayForKey("cities"){
            if myCities.count > 0{
                self.cities = myCities as? [String]
            }
            else{
                getMyCities()
            }
        }
        else{
            getMyCities()
        }
    }
    
    func getMyCities(){
        let defaults = NSUserDefaults()
        HTTP.get("/users/\(self.id)/cities") { (response) in
            if let myCities = response["cities"].array{
                for city in myCities{
                    self.cities!.append(city["name"].string!+","+city["state"].string!)
                }
                defaults.setObject(self.cities, forKey: "cities")
            }
        }
    }
    
    func setSports(){
        let defaults = NSUserDefaults()
        if let mySports: [AnyObject] = defaults.arrayForKey("sports"){
            self.sports = mySports as? [String]
        }
        else{
            HTTP.get("/users/\(self.id)/sports") { (response) in
                if let mySports = response["sports"].array{
                    for sport in mySports{
                        self.sports!.append(sport["name"].string!)
                    }
                    defaults.setObject(self.sports, forKey: "cities")
                }
            }
        }
    }
    
    func setGames(callback:ApiResponse){
        self.games = []
        HTTP.get("/users/\(GlobalStorage.currentUser.id)/games"){ (response) in
            if response["games"].array!.count > 0{
                for(key, game) in response["games"]{
                    var g = Game.jsonToGame(game)
                    var players = [Person]()
                    for(key, player) in game["players"]{
                        players.append(Person(username: player["username"].string!, id: player["id"].int!, email: player["email"].string!))
                    }
                    g.players = players
                    self.games.append(g)
                    callback(response)
                }
            }
            else{
                callback(response)
            }
        }
    }
    
    // city strings format: CityName, ST  <-- state abbreviation
    func addCities(citiesFollowingStrings:[String], callback:ApiResponse){
        HTTP.post("/users/\(GlobalStorage.currentUser.id)/cities", params: ["cities": citiesFollowingStrings]){
            (response) in
            if response["status"] == 200{
                let defaults = NSUserDefaults()
                defaults.setObject(citiesFollowingStrings, forKey: "cities")
                self.cities = citiesFollowingStrings
                callback(response)
            }
        }
    }
    
    func addSports(selectedSportStrings:[String], callback:ApiResponse){
        HTTP.post("/users/\(GlobalStorage.currentUser.id)/sports", params: ["sports": selectedSportStrings]){
            (response) in
            if response["status"] == 200{
                let defaults = NSUserDefaults()
                defaults.setObject(selectedSportStrings, forKey: "sports")
                self.sports = selectedSportStrings
                callback(response)
            }
        }
    }
}






