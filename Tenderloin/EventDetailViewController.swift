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
    @IBOutlet var contactButton: UIButton!
    
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
                let distance = currentLocation.distanceFromLocation(placemark!.location!) / 1609.344
                self.locationLabel.text = "\(placemark!.subLocality) - \(distance)mi"
            } else {
                self.locationLabel.text = placemark!.subLocality
            }
        }
        
        self.seatingCountLabel.text = "\(self.event!.numberOfSeats)"
        self.seatingView.reloadData()
        
        for (index, user) in self.event!.attendees.enumerate() {
            self.takenSeats[index] = user.objectId
        }
        
        if self.event!.authorEmail == PFUser.currentUser()!.username! {
            self.contactButton.setTitle("Delete", forState: .Normal)
        }
    }
    
    // MARK: Responders
    @IBAction func contactButtonWasPressed(sender: UIButton!) {
        // User is contact
        if self.event!.authorEmail == PFUser.currentUser()!.username! {
            let confirmationAlert = UIAlertController(title: "Are you sure?",
                message: "You'll have to host the event again, if you change your mind.",
                preferredStyle: .Alert)
            confirmationAlert.view.tintColor = self.view.backgroundColor
            
            confirmationAlert.addAction(UIAlertAction(title: "Cancel",
                style: .Cancel,
                handler: nil))
            confirmationAlert.addAction(UIAlertAction(title: "Delete", style: .Default) { (_: UIAlertAction!) in
                self.event!.deleteInBackgroundWithBlock(nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
            
            self.presentViewController(confirmationAlert,
                animated: true,
                completion: nil)
        }
        
        // Otherwise...
        let subject = NSString(string: "Tenderloin: \(self.dateLabel.text)").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let body = NSString(string: "Put me down for 1. Pay at the door?").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let mailURL = NSURL(string: "mailto://\(self.event!.authorEmail)?subject=\(subject)&body=\(body)")!
        UIApplication.sharedApplication().openURL(mailURL)
    }
}

extension EventDetailViewController: SeatingViewDataSource {
    func seatingViewNumberOfSeats(seatingView: SeatingView) -> Int {
        return self.event!.numberOfSeats
    }
    
    func seatingView(seatingView: SeatingView, colorForSeatAtIndex seatIndex: Int) -> UIColor {
        if self.takenSeats[seatIndex] == nil {
            return self.navigationController!.navigationBar.titleTextAttributes![NSForegroundColorAttributeName] as! UIColor
        }
        
        return UIColor.whiteColor()
    }
    
    func seatingView(seatingView: SeatingView, seatIsPushedInAtIndex index: Int) -> Bool {
        return self.takenSeats[index] != nil
    }
    
    func seatingView(seatingView: SeatingView, imageForSeatAtIndex seatIndex: Int) -> UIImage {
        return UIImage(named: "chair")!
    }
}
