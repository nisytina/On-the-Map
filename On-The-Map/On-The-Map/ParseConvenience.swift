//
//  Convenience.swift
//  On-The-Map
//
//  Created by Tina Ni on 24/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import UIKit
import Foundation

extension ParseClient {
    
    // MARK: GET Convenience Methods
    
    func getStudentLocations(completionHandlerForStdLocations: (result: [StudentLocation]?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters : [String:AnyObject] = [ParseClient.ParameterKey.limit: 100]
        parameters[ParseClient.ParameterKey.order] = "-" + ParseClient.JSONResponseKeys.StudentLocationUpdatedAt
        let mutableMethod: String = ParseClient.ParseMethods.studentLocation
        
        /* 2. Make the request */
        taskForGETMethod(mutableMethod, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStdLocations(result: nil, error: error)
            } else {
                
                if let results = results[ParseClient.JSONResponseKeys.result] as? [[String:AnyObject]] {
                    
                    let locations = StudentLocation.locationsFromResults(results)
                    completionHandlerForStdLocations(result: locations, error: nil)
                } else {
                    completionHandlerForStdLocations(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
    // MARK: GET uesr student location
    
    func getUserStudentLocation(completionHandlerForUserStdLocations: (result: AnyObject?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
//        let jsonData = ["uniqueKey":"\(UdacityClient.sharedInstance().UserID!)"]
        let parameters = [ParseClient.ParameterKey.query: "{\"uniqueKey\":\"\(UdacityClient.sharedInstance().UserID!)\"}"]
        let mutableMethod: String = ParseClient.ParseMethods.studentLocation
        
        /* 2. Make the request */
        taskForGETMethod(mutableMethod, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForUserStdLocations(result: nil, error: error)
            } else {
                if let result = results[ParseClient.JSONResponseKeys.result] as? [[String:AnyObject]] {
                    UdacityClient.sharedInstance().objectId = result[0][JSONResponseKeys.StudentLocationObjectId] as? String
                    completionHandlerForUserStdLocations(result: true, error: nil)
                } else {
                    completionHandlerForUserStdLocations(result: nil, error: NSError(domain: "getUserStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getUserStudentLocations"]))
                }
            }
        }
        
    }
    
    func updateLocation(jsonBody: String, completionHandlerForupdateLocation: (result: Bool, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = ["":""]
        let mutableMethod: String = ParseClient.ParseMethods.studentLocation + "/<objectId>"
        let finalMethod = Convenience.subtituteKeyInMethod(mutableMethod, key: "objectId", value: UdacityClient.sharedInstance().objectId!)!
        let jsonBody = jsonBody
        
        /* 2. Make the request */
        taskForPOSTandPUTMethod("PUT", method: finalMethod, parameters: parameters, jsonBody: jsonBody) { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForupdateLocation(result: false, error: error)
            } else {
                
                if let _ = result[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] as? String {
                    completionHandlerForupdateLocation(result: true, error: nil)
                } else {
                    completionHandlerForupdateLocation(result: false, error: NSError(domain: "updateLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse updateLocation"]))
                }
            }
        }
    }
    
    func putNewLocation(jsonBody: String, completionHandlerForNewLocation: (result: Bool, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = ["":""]
        let mutableMethod: String = ParseClient.ParseMethods.studentLocation
        let jsonBody = jsonBody
        
        /* 2. Make the request */
        taskForPOSTandPUTMethod("POST", method: mutableMethod, parameters: parameters, jsonBody: jsonBody) { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForNewLocation(result: false, error: error)
            } else {
                
                if let objectId = result[ParseClient.JSONResponseKeys.StudentLocationObjectId] as? String {
                    UdacityClient.sharedInstance().objectId = objectId
                    completionHandlerForNewLocation(result: true, error: nil)
                } else {
                    completionHandlerForNewLocation(result: false, error: NSError(domain: "putNewLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse putNewLocation"]))
                }
            }
        }
    }
}


