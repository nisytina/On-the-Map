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
        UdacityClient.sharedInstance().destroySession {(result, error) in
            if let error = error {
                print(error)
                Convenience.alert(self, title: "Error", message: "Can't logout. Try again later", actionTitle: "Dismiss")
            } else {
                if let _ = result {
                    performUIUpdatesOnMain {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        }
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

}
