//
//  Comment.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/10/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import Foundation
import SwiftyJSON

class Comment {
    var body: String!
    var author: Person!
    var postedAt: NSDate?
    var game: Game?
    init(body:String, author: Person, postedAt:NSDate){
        self.body = body
        self.author = author
        self.postedAt = postedAt
    }
    init(body:String, author: Person, game: Game){
        self.body = body
        self.author = author
        self.game = game
    }
    
    func create(gameID:Int, callback:ApiResponse){
        HTTP.post("/games/\(self.game!.id!)/comments", params: ["body":self.body]){ (response) in
            callback(response)
        }
    }
}
