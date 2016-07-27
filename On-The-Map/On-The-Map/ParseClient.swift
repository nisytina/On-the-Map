//
//  ParseClient.swift
//  On-The-Map
//
//  Created by Tina Ni on 23/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(method: String, parameters: [String:AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        print(tmdbURLFromParameters(parametersWithApiKey, withPathExtension: method))
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: tmdbURLFromParameters(parametersWithApiKey, withPathExtension: method))
        request.addValue(ParseAPIValue.Parse_Application_ID, forHTTPHeaderField: ParseAPIKey.Parse_Application_ID)
        request.addValue(ParseAPIValue.REST_API_Key, forHTTPHeaderField: ParseAPIKey.REST_API_Key)
        if let _ = parameters["where"] {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            Convenience.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: tmdbURLFromParameters(parameters, withPathExtension: method))
        request.HTTPMethod = "POST"
        request.addValue(ParseAPIValue.Parse_Application_ID, forHTTPHeaderField: ParseAPIKey.Parse_Application_ID)
        request.addValue(ParseAPIValue.REST_API_Key, forHTTPHeaderField: ParseAPIKey.REST_API_Key)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            Convenience.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            //print(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        return task
    }
    
    
    // create a URL from parameters
    private func tmdbURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        var URLString: String = ""
        
        let components = NSURLComponents()
        components.scheme = ParseConstants.ApiScheme
        components.host = ParseConstants.ApiHost
        components.path = ParseConstants.ApiPath + (withPathExtension ?? "")
        
        URLString = URLString + components.scheme! + "://" + components.host! + components.path! + "?"
        
        //components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
        
            if (key == "") {
                continue
            }
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            //components.queryItems!.append(queryItem)
            let query: String = queryItem.name + "=" + queryItem.value!
            let newQ = query.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())
            URLString += newQ!
            URLString += "&"
            
        }
        return NSURL(string: URLString)!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }

    
}
