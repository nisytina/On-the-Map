//
//  MapViewController.swift
//  On-The-Map
//
//  Created by Tina Ni on 23/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var appDelegate: AppDelegate!

    //MARK: Properties
    var locations: [studentLocation] = [studentLocation]()
    var message: String! = nil
    var updateLocation: Bool = false
    
    @IBOutlet weak var mapView: MKMapView!
    //@IBOutlet weak var logOut: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self;
        //print(message)
    }
        
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().getStudentLocations { (locations, error) in
            if let locations = locations {
                self.locations = locations
                
                performUIUpdatesOnMain {
                    self.displayStudentLocations(locations)
                }
            } else {
                print(error)
            }
        }
    }
    
    @IBAction func addNew(sender: AnyObject) {
        
        ParseClient.sharedInstance().getUserStudentLocation { (result, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            if let _ = result {
                // need to update
                let alertController = UIAlertController(title: nil, message:
                    "User " + "\(UdacityClient.sharedInstance().firstName!) " + "\(UdacityClient.sharedInstance().lastName!) Has Already Posted a Student Location. Would you Like to Overwrite Their Location?", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel,handler: nil))
                alertController.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
                    performUIUpdatesOnMain{
                        self.updateLocation = true
                        self.performSegueWithIdentifier("AddNew", sender: self)
                    }
                }))
                performUIUpdatesOnMain{
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                performUIUpdatesOnMain{
                    self.performSegueWithIdentifier("AddNew", sender: self)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddNew" {
            let addNewViewController = segue.destinationViewController as! AddNewViewController
            addNewViewController.updateLoaction = updateLocation
        }
        
    }
    
    // MARK: Logout
    
    @IBAction func logout(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func displayStudentLocations(results: [studentLocation]) {
        
        for result in results {
            let location = CLLocationCoordinate2DMake(result.latitude, result.longitude)
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = location
            dropPin.title = result.firstName + " " + result.lastName
            dropPin.subtitle = result.mediaURL
            mapView.addAnnotation(dropPin)
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "locations"
        let buttonType = UIButtonType.InfoDark
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        
        pinView.canShowCallout = true
        pinView.rightCalloutAccessoryView = UIButton(type: buttonType)
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            let link = ((view.annotation?.subtitle)!)! as String
            
            if let requestUrl = NSURL(string: link) {
                if UIApplication.sharedApplication().canOpenURL(requestUrl) {
                    UIApplication.sharedApplication().openURL(requestUrl)
                } else {
                    
                    let alertController = UIAlertController(title: "Error", message:
                        "invalid link", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
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
                        print(error)
                    }
                }
                return
            }
            
            /* GUARD: Is the session created sucessfully?  */
            guard let session = parsedResult[UdacityJSONResponseKeys.Session] as? [String:String] else {
                print("Cannot get session id")
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
