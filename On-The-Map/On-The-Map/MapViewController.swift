//
//  MapViewController.swift
//  On-The-Map
//
//  Created by Tina Ni on 23/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    var message: String! = nil
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logOut: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        print(message)
    }
    
    @IBAction func logout() {
        
        deleteSession()
        print("poped")
        
    }
    
    func deleteSession() {
        
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityMethods.Session)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            //            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            //                print("Your request returned a status code other than 2xx!")
            //                return
            //            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            /* 5A. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            /* GUARD: Did Udacity return an error? */
            if let _ = parsedResult[UdacityJSONResponseKeys.StatusCode] as? Int {
                performUIUpdatesOnMain {
                    if let error = parsedResult[UdacityJSONResponseKeys.StatusMessage]! {
//                        self.errorMessage.text =
//                            error as? String
                        print(error)
                    }
                    
                }
                return
            }
            
            /* GUARD: Is the session created sucessfully?  */
            guard let session = parsedResult[UdacityJSONResponseKeys.Session] as? [String:String] else {
                print("Cannot create new session")
                return
            }
            
            
            
            if session[UdacityJSONResponseKeys.SessionID] == self.appDelegate.sessionID {
                print("sessin not destroyed")
                return
            }
            performUIUpdatesOnMain {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        task.resume()
        
    }
    
    

}
