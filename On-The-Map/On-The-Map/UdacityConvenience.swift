//
//  UdacityConvenience.swift
//  On-The-Map
//
//  Created by 倪世莹 on 25/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    func createSession(email: String, password: String, errorMessage: UILabel, completionHandlerForCrSession: (result: [String:String], error: NSError?) -> Void) {
        let mutableMethod: String = UdacityMethods.Session
        
        let jsonBody: String = "{\"udacity\": {\"\(UdacityJSONBodyKeys.Username)\": \"\(email)\", \"\(UdacityJSONBodyKeys.Password)\": \"\(password)\"}}"
        taskForPOSTMethod(mutableMethod, jsonBody: jsonBody) {(result, error) in
            
            if let error = error {
                completionHandlerForCrSession(result: ["":""], error: error)
            } else {
                
                /* GUARD: Did Udacity return an error? */
                if let _ = result[UdacityJSONResponseKeys.StatusCode] as? Int {
                    performUIUpdatesOnMain {
                        if let error = result[UdacityJSONResponseKeys.StatusMessage]! {
                            errorMessage.text =
                                error as? String
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
    
    func destroySession() {
        
    }
}
