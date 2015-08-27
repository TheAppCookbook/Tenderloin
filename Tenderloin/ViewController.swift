//
//  ViewController.swift
//  Tenderloin
//
//  Created by PATRICK PERINI on 8/27/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var seatingView: SeatingView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seatingView.reloadData()
    }
}

extension ViewController: SeatingViewDataSource {
    func seatingViewNumberOfSeats(seatingView: SeatingView) -> Int {
        return 5
    }
    
    func seatingView(seatingView: SeatingView, colorForSeatAtIndex seatIndex: Int) -> UIColor {
        return UIColor.redColor()
    }
    
    func seatingView(seatingView: SeatingView, seatIsPushedInAtIndex index: Int) -> Bool {
        return index == 3
    }
}

