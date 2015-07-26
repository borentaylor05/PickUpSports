//
//  Person.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/10/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import Foundation

class Person {
    var username: String!
    var email: String!
    var token: String!
    var id: Int?
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
}