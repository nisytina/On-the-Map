//
//  GCDBlackBox.swift
//  On-The-Map
//
//  Created by Tina Ni on 29/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}
