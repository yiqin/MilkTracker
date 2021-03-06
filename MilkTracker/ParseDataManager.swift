//
//  ParseDataManager.swift
//  MilkTracker
//
//  Created by Yi Qin on 6/3/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class ParseDataManager: NSObject {
    
    
    
    
    
    class var sharedInstance : ParseDataManager {
        struct Static {
            static let instance = ParseDataManager()
        }
        return Static.instance
    }
    
    
    /// Load Live Stream feed data in the same Channel.
    class func loadDataFromParse(pageIndex:Int, completionClosure: (success :Bool, hasMore:Bool, objects:[AnyObject]?) ->()) {
        
        
    
        let query = PFQuery(className: "MilkValue")
        
        query.orderByDescending("createdAt")
        
        query.limit = 1000
    
    
        // query.limit = trendingObjectsPerPage
        // query.skip = trendingObjectsPerPage*pageIndex
        // query.orderByDescending("updatedAt")
        // query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error:NSError?) -> Void in
            /*
            // remove repeat object
            var tempSet:NSMutableSet = []
            var results:[AnyObject] = []
            for object in objects as! [PFObject] {
            let trackId = object["trackId"] as! String
            if !tempSet.containsObject(trackId) {
            tempSet.addObject(trackId)
            results += [object]
            }
            }
            */
            
            // For future use. Please ignore it now.
            /*
            var tempFeeds:[App] = []
            for object in objects as! [PFObject] {
            let feed = Product(parseObject: object)
            tempFeeds += [feed]
            }
            */
            
            /*
            var tempHasMore:Bool = false
            if objects?.count < self.trendingObjectsPerPage {
            tempHasMore = false
            }
            else {
            tempHasMore = true
            }
            */
            
            completionClosure(success: true, hasMore: false, objects: objects)
        }
    }

    
}
