//
//  CreateEventViewController.swift
//  Tenderloin
//
//  Created by PATRICK PERINI on 8/27/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import Parse

class CreateEventViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var postButton: UIBarButtonItem!
    
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var seatingView: SeatingView!
    @IBOutlet var decreaseSeatCountButton: UIButton!
    @IBOutlet var seatCountTextField: UITextField!
    @IBOutlet var increaseSeatCountButton: UIButton!
    
    private var pushedInSeatIndices: [Int] = []
    private var seatCount: Int = 4 {
        didSet {
            self.seatCountTextField.text = "\(self.seatCount)"
            self.seatingView.reloadData()
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.postButton
        
        self.decreaseSeatCountButton.layer.borderColor = self.decreaseSeatCountButton.tintColor?.CGColor
        self.increaseSeatCountButton.layer.borderColor = self.increaseSeatCountButton.tintColor?.CGColor
        
        self.seatingView.reloadData()
    }
    
    // MARK: Responders
    @IBAction func decreaseSeatCountButtonWasPressed(sender: UIButton!) {
        self.seatCount--
    }
    
    @IBAction func increaseSeatCountButtonWasPressed(sender: UIButton!) {
        self.seatCount++
    }
    
    @IBAction func textFieldDidExit(sender: UITextField!) {
        sender.resignFirstResponder()
        
        // Input changed...
        self.seatCount = (self.seatCountTextField.text as NSString!).integerValue
    }
    
    @IBAction func postButtonWasPressed(sender: UIBarButtonItem!) {
        let description = self.descriptionTextField.text
        let address = self.addressTextField.text
        let price = (self.priceTextField.text as NSString!).integerValue
        let seatCount = (self.seatCountTextField.text as NSString!).integerValue
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d"
        dateFormatter.lenient = true
        let date = dateFormatter.dateFromString(self.dateTextField.text)!
        
        let event = Event()
        event.eventDescription = description
        event.address = address
        event.date = date
        event.price = price
        event.numberOfSeats = seatCount
        event.authorEmail = PFUser.currentUser()!.username!
        
        event.save()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}

extension CreateEventViewController: SeatingViewDataSource {
    func seatingViewNumberOfSeats(seatingView: SeatingView) -> Int {
        return self.seatCount
    }
    
    func seatingView(seatingView: SeatingView, colorForSeatAtIndex seatIndex: Int) -> UIColor {
        return self.navigationController!.navigationBar.titleTextAttributes![NSForegroundColorAttributeName] as! UIColor
    }
    
    func seatingView(seatingView: SeatingView, imageForSeatAtIndex seatIndex: Int) -> UIImage {
        return UIImage(named: "chair")!
    }
}
