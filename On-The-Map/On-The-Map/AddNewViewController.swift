//
//  AddNewController.swift
//  On-The-Map
//
//  Created by Tina Ni on 26/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class AddNewViewControllrt: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet var backView: UIView!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var locationLabel1: UILabel!
    @IBOutlet weak var locationLabel2: UILabel!
    @IBOutlet weak var locationLabel3: UILabel!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var buttonBackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SubmitButton.hidden = true
        linkTextView.hidden = true
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func changeView() {
        
        backView.backgroundColor = locationTextView.backgroundColor
        buttonBackView.backgroundColor = UIColor.clearColor()
        linkTextView.hidden = false
        SubmitButton.hidden = false
        locationLabel1.hidden = true
        locationLabel2.hidden = true
        locationLabel3.hidden = true
        locationTextView.hidden = true
        findLocationButton.hidden = true
        
    }
    
    @IBAction func findLocation(sender: AnyObject) {
        
        //geocode the location string pin that location on map
        geocodeLocation(locationTextView.text)
        
    }
    
    private func geocodeLocation(location: String) {
        
        let address = location
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                Convenience.alert(self, title: "Error", message: "Can't geocode the location", actionTitle: "Try again")
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                self.changeView()
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                let location = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = location
                self.mapView.addAnnotation(dropPin)
                
                // optionally you can set your own boundaries of the zoom
                let span = MKCoordinateSpanMake(0.01, 0.01)
                
                // now move the map
                let region = MKCoordinateRegion(center: dropPin.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
        })
        
    }
    
    
    @IBAction func submit(sender: AnyObject) {
        
        //send request to Parse to PUT new data
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    
}
