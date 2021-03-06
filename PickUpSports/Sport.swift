//
//  Sport.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/9/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import Foundation

class Sport: UserSettings {
    var name: String!
    var players: Int?
    init(name:String){
        self.name = name
    }
    
    static func getAll(callback:ApiResponse){
        HTTP.get("/sports"){ (response) in
            callback(response)
        }
    }
}