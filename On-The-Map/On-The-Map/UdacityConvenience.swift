//
//  UdacityConvenience.swift
//  On-The-Map
//
//  Created by Tina Ni on 25/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    func createSession(email: String, password: String, completionHandlerForCrSession: (result: [String: String], error: NSError?) -> Void) {
        let mutableMethod: String = UdacityMethods.Session
        var errorMessage: String = ""
        
        let jsonBody: String = "{\"udacity\": {\"\(UdacityJSONBodyKeys.Username)\": \"\(email)\", \"\(UdacityJSONBodyKeys.Password)\": \"\(password)\"}}"
        taskForPOSTMethod(mutableMethod, jsonBody: jsonBody) {(result, error) in
            
            if let error = error {
                completionHandlerForCrSession(result: ["":""], error: error)
            } else {
                
                /* GUARD: Did Udacity return an error? */
                if let _ = result[UdacityJSONResponseKeys.StatusCode] as? Int {
                    performUIUpdatesOnMain {
                        if let error = result[UdacityJSONResponseKeys.StatusMessage]!{
                            errorMessage = error as! String
                            print(errorMessage)
                            completionHandlerForCrSession(result: ["":""], error: NSError(domain: errorMessage, code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not auth to login"]))
                        }
                    }
                    return
                }
                
                if let account = result[UdacityJSONResponseKeys.Account] as? [String:AnyObject] {
                    if let session = result[UdacityJSONResponseKeys.Session] as? [String:String] {
                        if account[UdacityJSONResponseKeys.Registration] as! Bool == true {
                            var sessionInfo: [String:String] = ["":""]
                            sessionInfo[UdacityJSONResponseKeys.SessionID] = session[UdacityJSONResponseKeys.SessionID]
                            sessionInfo[UdacityJSONResponseKeys.UserID] = account[UdacityJSONResponseKeys.UserID] as? String
                            completionHandlerForCrSession(result: sessionInfo, error: nil)
                        } else {
                            completionHandlerForCrSession(result: ["":""], error: NSError(domain: "createSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find account information"]))
                        }
                
                    } else {
                        completionHandlerForCrSession(result: ["":""], error: NSError(domain: "createSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find session information"]))
                    }
                } else {
                    completionHandlerForCrSession(result: ["":""], error: NSError(domain: "createSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find results returned"]))
                }
        
            }
        }
    
    }
    
    func getUserInfo(completionHandlerForUserInfo: (result: AnyObject?, error: NSError?) -> Void) {
        let finalMethod = Convenience.subtituteKeyInMethod(UdacityMethods.Users, key: "user_id", value: UserID!)
        taskForGETMethod(finalMethod!) {(result, error) in
            if let error = error {
                completionHandlerForUserInfo(result: nil, error: error)
            } else {
                if let user = result[UdacityJSONResponseKeys.user] as! [String: AnyObject]? {
                let result = true
                UdacityClient.sharedInstance().firstName = user[UdacityJSONResponseKeys.firstname] as? String
                UdacityClient.sharedInstance().lastName = user[UdacityJSONResponseKeys.lastname] as? String
                completionHandlerForUserInfo(result: result, error: error)
                    
                } else {
                    completionHandlerForUserInfo(result: nil, error: NSError(domain: "UserInfo parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find User Info"]))
                }
            }
        }
    }
    
    func destroySession(completionHandlerForDelete: (result: AnyObject?, error: NSError?) -> Void) {
        
        taskForDELETEMethod { (result, error) in
            if let error = error {
                completionHandlerForDelete(result: nil, error: error)
            } else {
                if let session = result[UdacityJSONResponseKeys.Session] as? [String:String] {
                    if session[UdacityJSONResponseKeys.SessionID] != UdacityClient.sharedInstance().SessionID {
                        completionHandlerForDelete(result: true, error: nil)
                    } else {
                        completionHandlerForDelete(result: nil, error: NSError(domain: "Delete session", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not destroy session"]))
                    }
                } else {
                    completionHandlerForDelete(result: nil, error: NSError(domain: "Delete session", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session info"]))
                }
            }
        }
    }
}
