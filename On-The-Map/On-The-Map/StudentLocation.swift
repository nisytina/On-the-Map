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
        objectId = dictionary[ParseClient.JSONResponseKeys.StudentLocationObjectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.StudentLocationUniqueKey] as! String
        firstName = dictionary[ParseClient.JSONResponseKeys.StudentLocationFirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.StudentLocationLastName] as! String
        mapString = dictionary[ParseClient.JSONResponseKeys.StudentLocationMapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.StudentLocationMediaURL] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.StudentLocationLatitude] as! Float64
        longitude = dictionary[ParseClient.JSONResponseKeys.StudentLocationLongitude] as! Float64
        createdAt = dictionary[ParseClient.JSONResponseKeys.StudentLocationCreatedAt] as! CFDate
        updatedAt = dictionary[ParseClient.JSONResponseKeys.StudentLocationUpdatedAt] as! CFDate
    }

    
    static func locationsFromResults(results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var locations = [StudentLocation]()
        
        // iterate through array of dictionaries, each  is a dictionary
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }

    
}
