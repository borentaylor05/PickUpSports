//
//  City.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/7/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import Foundation

class City: UserSettings {
    var name: String!
    var state: String!
    init(name:String, state:String){
        self.name = name
        self.state = state
    }
    
    func toString() -> String{
        return self.name+","+self.state
    }
    
    static func getAll(callback:ApiResponse){
        HTTP.get("/cities"){ (response) in
            callback(response)
        }
    }
    
}