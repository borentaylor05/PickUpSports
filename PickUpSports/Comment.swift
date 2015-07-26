//
//  Comment.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/10/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import Foundation

class Comment {
    var body: String!
    var author: Person!
    var postedAt: NSDate!
    init(body:String, author: Person, postedAt:NSDate){
        self.body = body
        self.author = author
        self.postedAt = postedAt
    }
}
