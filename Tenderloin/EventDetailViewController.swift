//
//  EventDetailViewController.swift
//  Tenderloin
//
//  Created by PATRICK PERINI on 8/27/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class EventDetailViewController: UIViewController {
    // MARK: Properties
    var event: Event?
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionTextLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var seatingCountLabel: UILabel!
    @IBOutlet var seatingView: SeatingView!
    @IBOutlet var priceLabel: UILabel!
    
    private var takenSeats: [Int: String] = [:] /* Index: Object ID */
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE MM/dd"
        self.dateLabel.text = dateFormatter.stringFromDate(self.event!.date)
        
        self.descriptionTextLabel.text = self.event!.eventDescription
        self.priceLabel.text = "$\(self.event!.price)/seat"
        
        self.event!.placemark { (placemark: CLPlacemark?) in
            if let currentLocation = AppDelegate.sharedAppDelegate?.locationManager?.location {
                let distance = currentLocation.distanceFromLocation(placemark!.location) / 1609.344
                self.locationLabel.text = "\(placemark!.subLocality) - \(distance)mi"
            } else {
                self.locationLabel.text = placemark!.subLocality
            }
        }
        
        self.seatingCountLabel.text = "\(self.event!.numberOfSeats)"
        self.seatingView.reloadData()
        
        for (index, user) in enumerate(self.event!.attendees) {
            self.takenSeats[index] = user.objectId
        }
    }
}

extension EventDetailViewController: SeatingViewDataSource {
    func seatingViewNumberOfSeats(seatingView: SeatingView) -> Int {
        return self.event!.numberOfSeats
    }
    
    func seatingView(seatingView: SeatingView, colorForSeatAtIndex seatIndex: Int) -> UIColor {
        return UIColor.blueColor()
    }
    
    func seatingView(seatingView: SeatingView, seatIsPushedInAtIndex index: Int) -> Bool {
        return self.takenSeats[index] != nil
    }
}

extension EventDetailViewController: SeatingViewDelegate {
    func seatingView(seatingView: SeatingView, seatWasTappedAtIndex index: Int) {
        if let attendee = self.takenSeats[index] {
            if attendee == PFUser.currentUser()?.objectId {
                self.takenSeats.removeValueForKey(index)
            }
        } else {
            self.event!.attendees.append(PFUser.currentUser()!)
            self.takenSeats[index] = PFUser.currentUser()!.objectId
        }
        
        self.event!.saveInBackgroundWithBlock(nil)
        self.seatingView.reloadData()
    }
}
