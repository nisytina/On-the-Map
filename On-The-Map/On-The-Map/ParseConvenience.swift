//
//  Convenience.swift
//  On-The-Map
//
//  Created by 倪世莹 on 24/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import UIKit
import Foundation

extension ParseClient {
    
    // MARK: GET Convenience Methods
    
    func getStudentLocations(completionHandlerForStdLocations: (result: [studentLocation]?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [ParseClient.ParameterKey.limit: 100]
        let mutableMethod: String = ParseClient.ParseMethods.studentLocation
        
        /* 2. Make the request */
        taskForGETMethod(mutableMethod, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStdLocations(result: nil, error: error)
            } else {
                
                if let results = results[ParseClient.JSONResponseKeys.result] as? [[String:AnyObject]] {
                    
                    let locations = studentLocation.locationsFromResults(results)
                    completionHandlerForStdLocations(result: locations, error: nil)
                } else {
                    completionHandlerForStdLocations(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
}


