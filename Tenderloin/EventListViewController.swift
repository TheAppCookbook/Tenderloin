//
//  EventListViewController.swift
//  Tenderloin
//
//  Created by PATRICK PERINI on 8/27/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import Parse

class EventListViewController: UICollectionViewController {
    // MARK: Properties
    private var events: [Event] = []
    weak var homeViewController: HomeViewController?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.currentUser() == nil {
            self.performSegueWithIdentifier("PresentLogin",
                sender: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadData()
    }
    
    // MARK: Data Handlers
    private func reloadData() {
        Event.query()?.findObjectsInBackgroundWithBlock({ (events: [AnyObject]?, err: NSError?) in
            self.events = events as! [Event]
            self.collectionView?.reloadData()
        })
    }
}

extension EventListViewController: UICollectionViewDataSource {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.events.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let event = self.events[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EventCell",
            forIndexPath: indexPath) as! UICollectionViewCell
        
        let dateLabel = cell.viewWithTag(1) as! UILabel
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E MM/dd"
        dateLabel.text = dateFormatter.stringFromDate(event.date)
        
        let descriptionLabel = cell.viewWithTag(2) as! UILabel
        descriptionLabel.text = event.eventDescription
        
        let priceLabel = cell.viewWithTag(3) as! UILabel
        priceLabel.text = "$\(event.price)"
        
        return cell
    }
}

extension EventListViewController: UICollectionViewDelegate {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let event = self.events[indexPath.row]
        self.homeViewController?.performSegueWithIdentifier("PushDetail",
            sender: event)
    }
}
