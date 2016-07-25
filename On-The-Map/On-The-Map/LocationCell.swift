//
//  LocationCell.swift
//  On-The-Map
//
//  Created by Tina Ni on 25/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell{
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var linkText: UILabel!
    
    func setText(name: String, link: String) {
        
        nameText.text = name
        linkText.text = link
        
    }

    
    
    
}
