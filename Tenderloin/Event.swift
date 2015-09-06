//
//  Event.swift
//  Tenderloin
//
//  Created by PATRICK PERINI on 8/27/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import Parse
import CoreLocation

class Event: PFObject, PFSubclassing {
    // MARK: Properties
    @NSManaged var authorEmail: String
    @NSManaged var date: NSDate
    @NSManaged var eventDescription: String
    @NSManaged var address: String
    @NSManaged var price: Int
    @NSManaged var numberOfSeats: Int
    @NSManaged var attendees: [PFUser]
    
    static func parseClassName() -> String {
        return "Event"
    }
    
    func placemark(completion: (CLPlacemark?) -> Void) {
        CLGeocoder().geocodeAddressString(self.address) { (placemarks: [CLPlacemark]?, error: NSError?) in
            completion(placemarks?.first)
        }
    }
}
