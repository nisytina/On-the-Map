//
//  ParseConstants.swift
//  On-The-Map
//
//  Created by Tina Ni on 23/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

extension ParseClient {
    
    struct ParseAPIKey {
        static let Parse_Application_ID = "X-Parse-Application-Id"
        static let REST_API_Key = "X-Parse-REST-API-Key"
    }
    
    struct ParseAPIValue {
        static let Parse_Application_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let REST_API_Key = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct ParseMethods {
        static let studentLocation = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    struct ParameterKey {
        
    }
    
    struct JSONResponseKeys {
        
        //MARK: result
        static let result = "results"
        
        // MARK: StudentLocation
        static let StudentLocationObjectId = "objectId"
        static let StudentLocationUniqueKey =  "uniqueKey"
        static let StudentLocationFirstName = "firstName"
        static let StudentLocationLastName = "lastName"
        static let StudentLocationMapString = "mapString"
        static let StudentLocationMediaURL = "mediaURL"
        static let StudentLocationLatitude = "latitude"
        static let StudentLocationLongitude = "longitude"
        static let StudentLocationCreatedAt = "createdAt"
        static let StudentLocationUpdatedAt = "updatedAt"
        static let StudentLocationACL = "ACL"
        
        
    }

}






