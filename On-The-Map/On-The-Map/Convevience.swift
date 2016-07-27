//
//  Convevience.swift
//  On-The-Map
//
//  Created by 倪世莹 on 25/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import Foundation
import UIKit

class Convenience {
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    static func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
            
        if method.rangeOfString("<\(key)>") != nil {
            return method.stringByReplacingOccurrencesOfString("<\(key)>", withString: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    static func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    static func alertWithOption (sender: AnyObject?, title: String, message: String, actionTitle: String){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
            
            
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel,handler: nil))
        
        sender!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    static func alert(sender: AnyObject?, title: String, message: String, actionTitle: String){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default,handler: nil))
        
        sender!.presentViewController(alertController, animated: true, completion: nil)
    }
    
}


