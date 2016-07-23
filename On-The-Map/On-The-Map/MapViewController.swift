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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(message)
    }

}
