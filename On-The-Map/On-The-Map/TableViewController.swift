//
//  TableViewController.swift
//  On-The-Map
//
//  Created by 倪世莹 on 24/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    //MARK: Properties
    
    var locations: [studentLocation] = [studentLocation]()
    
    //MARK: Outlets
    
    @IBOutlet weak var locationsTableView: UITableView!
    
    //MARK: Life cycle
    
    func viewDidload() {
        super.viewDidLoad()
        // create and set the logout button
        parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: #selector(logout))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().getStudentLocations { (locations, error) in
            if let locations = locations {
                self.locations = locations
                performUIUpdatesOnMain {
                    self.locationsTableView.reloadData()
                }
            } else {
                print(error)
            }
        }
    }
    
    // MARK: Logout
    
    func logout() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
