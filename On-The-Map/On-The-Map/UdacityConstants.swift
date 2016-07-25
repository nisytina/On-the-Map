//
//  Constants.swift
//  On-The-Map
//
//  Created by Tina Ni on 22/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

struct UdacityConstants {
    // MARK: URLs
    static let ApiScheme = "https"
    static let ApiHost = "www.udacity.com"
    static let ApiPath = "/api"
}

// MARK: Methods
struct UdacityMethods {
    
    static let Session = "/session"
    static let Users = "/users"
    
}

// MARK: Parameter Keys
struct UdacityParameterKeys {
    
    static let UserId = "key"
    
}

// MARK: JSON Body Keys
struct UdacityJSONBodyKeys {
    
    static let Username = "username"
    static let Password = "password"
}

// MARK: JSON Response Keys
struct UdacityJSONResponseKeys {
    
    // MARK: General
    static let Account = "account"
    static let Session = "session"
    static let StatusMessage = "error"
    static let StatusCode = "status"
    
    // MARK: Authorization
    static let Registration = "registered"
    static let SessionID = "id"
    static let Expiration = "expiration"
    static let UserID = "key"
    
}
