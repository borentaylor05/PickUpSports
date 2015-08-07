//
//  HTTP.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/29/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import Alamofire
import SwiftyJSON

class HTTP {
    
    static func post(resource:String, params: [String:AnyObject]?, callback:ApiResponse){
        Alamofire.request(.POST, Util.formatUrl(resource), parameters: params).responseJSON{
            (req, resp, json, err) in
            let resp: JSON? = JSON(json!)
            callback(resp!)
        }
    }
    
    static func get(resource:String, callback:ApiResponse){
        Alamofire.request(.GET, Util.formatUrl(resource)).responseJSON{
            (req, resp, json, err) in
            let resp: JSON? = JSON(json!)
            callback(resp!)
        }
    }
    
}