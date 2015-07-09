//
//  Util.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/7/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import Foundation

class Util {
    
}

extension String{
    func trim() -> String{
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}