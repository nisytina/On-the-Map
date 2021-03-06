//
//  TableViewController.swift
//  On-The-Map
//
//  Created by Tina Ni on 24/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//
import Foundation
import UIKit

class TableViewController: UIViewController {
    
    //MARK: Properties
    var overlay : UIView?
    //MARK: Outlets
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var locationsTableView: UITableView!
    @IBOutlet weak var backView: UIView!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.locationsTableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         getLoc()
    }

    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    func getLoc() {
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.blackColor()
        overlay!.alpha = 0.4
        view.addSubview(overlay!)
        
        self.backView.hidden = false
        self.activityIndicatorView.hidden = false
        let seconds = 1.5
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        activityIndicatorView.startAnimating()
        ParseClient.sharedInstance().getStudentLocations { (locations, error) in
            if let locations = locations {
                StudentLocation.locations = locations
                performUIUpdatesOnMain {
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        
                        self.locationsTableView.reloadData()
                        self.activityIndicatorView.stopAnimating()
                        self.backView.hidden = true
                        self.overlay?.removeFromSuperview()
                    })
                }
            
            } else {
                performUIUpdatesOnMain {
                    self.activityIndicatorView.stopAnimating()
                    self.overlay?.removeFromSuperview()
                    Convenience.alert(self, title: "Error", message: "Can't get location info. Try again later", actionTitle: "OK")
                }
                print(error)
            }
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        getLoc()
    }
    
    @IBAction func addNew(sender: AnyObject) {
        
        ParseClient.sharedInstance().getUserStudentLocation { (result, error) in
            
            if let error = error {
                performUIUpdatesOnMain {
                    var errorMessage: String
                    if error.code == -1009 {
                        errorMessage = "connection fails. Can't add new location now. Try again later."
                    } else {
                        errorMessage = error.domain
                    }
                    Convenience.alert(self, title: "Error", message: errorMessage, actionTitle: "Dismiss")
                }
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
    // MARK: Logout
    @IBAction func logout() {
        UdacityClient.sharedInstance().destroySession {(result, error) in
            if let error = error {
                print(error)
                performUIUpdatesOnMain {
                    Convenience.alert(self, title: "Error", message: "Can't logout. Try again later", actionTitle: "Dismiss")
                }
            } else {
                if let _ = result {
                    performUIUpdatesOnMain {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        }
    }
    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "TableViewCell"
        let location = StudentLocation.locations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! LocationCell!
        
        /* Set cell defaults */
        cell.setText(location.firstName + " " + location.lastName, link: location.mediaURL)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocation.locations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let location = StudentLocation.locations[indexPath.row]
        let link = location.mediaURL
        
        if let requestUrl = NSURL(string: link) {
            if UIApplication.sharedApplication().canOpenURL(requestUrl) {
                UIApplication.sharedApplication().openURL(requestUrl)
            } else {
                
                Convenience.alert(self, title: "Error", message: "invalid link", actionTitle: "Dismiss")
            }
        } else {
            Convenience.alert(self, title: "Error", message: "invalid link", actionTitle: "Dismiss")
        }
    }
}
