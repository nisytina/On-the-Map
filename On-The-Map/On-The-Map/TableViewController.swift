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
    
    var locations: [studentLocation] = [studentLocation]()
    
    //MARK: Outlets
    
    @IBOutlet weak var locationsTableView: UITableView!
    
    //MARK: Life cycle
    func viewDidload() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationsTableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().getStudentLocations { (locations, error) in
            if let locations = locations {
                self.locations = locations
                performUIUpdatesOnMain {
                    self.locationsTableView.reloadData()
                    print("loaded")
                }
            } else {
                print(error)
            }
        }
    }
    
    // MARK: Logout
    @IBAction func logout() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "TableViewCell"
        let location = locations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! LocationCell!
        
        /* Set cell defaults */
        cell.setText(location.firstName + " " + location.lastName, link: location.mediaURL)
        
//        if let posterPath = location.posterPath {
//            TMDBClient.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.RowPoster, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
//                if let image = UIImage(data: imageData!) {
//                    performUIUpdatesOnMain {
//                        cell.imageView!.image = image
//                    }
//                } else {
//                    print(error)
//                }
//            })
//        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(locations.count)
        return locations.count
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let controller = storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
//        controller.movie = movies[indexPath.row]
//        navigationController!.pushViewController(controller, animated: true)
//    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 100
//    }
}
