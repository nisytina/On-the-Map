//
//  studentLocation.swift
//  On-The-Map
//
//  Created by Tina Ni on 23/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import Foundation
    

    
    struct StudentLocation {
        
        
        // MARK: Properties
        let objectId: String
        let uniqueKey: String
        let firstName: String
        let lastName: String
        let mapString: String
        let mediaURL: String
        let latitude: Float64
        let longitude: Float64
        let createdAt: NSDate
        let updatedAt: NSDate
        //let ACL: AnyObject
        
        // MARK: Initializers
        // construct a student from a dictionary
        init(dictionary: [String:AnyObject]) {
            if let id = dictionary[ParseClient.JSONResponseKeys.StudentLocationObjectId] {
                objectId = id as! String
            } else {
                objectId = ""
            }
            if let key = dictionary[ParseClient.JSONResponseKeys.StudentLocationUniqueKey] {
                uniqueKey = key as! String
            } else {
                uniqueKey = ""
            }
            if let fname = dictionary[ParseClient.JSONResponseKeys.StudentLocationFirstName] {
                firstName = fname as! String
            } else {
                firstName = ""
            }
            if let lname = dictionary[ParseClient.JSONResponseKeys.StudentLocationLastName] {
                lastName = lname as! String
            } else {
                lastName = ""
            }
            if let mS = dictionary[ParseClient.JSONResponseKeys.StudentLocationMapString] {
                mapString = mS as! String
            } else {
                mapString = ""
            }
            if let mU = dictionary[ParseClient.JSONResponseKeys.StudentLocationMediaURL] {
                mediaURL = mU as! String
            } else {
                mediaURL = ""
            }
            if let la = dictionary[ParseClient.JSONResponseKeys.StudentLocationLatitude] {
                latitude = la as! Float64
            } else {
                latitude = 0
            }
            if let lo = dictionary[ParseClient.JSONResponseKeys.StudentLocationLongitude] {
                longitude = lo as! Float64
            } else {
                longitude = 0
            }
            createdAt = dictionary[ParseClient.JSONResponseKeys.StudentLocationCreatedAt] as! CFDate
            updatedAt = dictionary[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] as! CFDate
        }
        
        static var locations: [StudentLocation] = [StudentLocation]()
        
        static func locationsFromResults(results: [[String:AnyObject]]) -> [StudentLocation] {
            
            var locations = [StudentLocation]()
            
            // iterate through array of dictionaries, each  is a dictionary
            for result in results {
                locations.append(StudentLocation(dictionary: result))
            }
            
            return locations
        }
    
    
    }

