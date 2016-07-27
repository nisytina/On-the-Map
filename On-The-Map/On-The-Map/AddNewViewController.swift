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
    
    @IBAction func findLocation(sender: AnyObject) {
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
    
    
    @IBAction func submit(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    
}
