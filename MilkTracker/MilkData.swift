//
//  MilkData.swift
//  MilkTracker
//
//  Created by Yi Qin on 6/3/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class MilkData: NSParseObject {
    
    var value:Float
    
    override init(parseObject: PFObject) {
        
        if let temp = parseObject["message"] as? NSNumber {
            value = temp.floatValue
        } else {
            value = 0
        }
        
        super.init(parseObject: parseObject)
        
    }
    
    
}
