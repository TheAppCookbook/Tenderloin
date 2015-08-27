//
//  SeatingView.swift
//  Tenderloin
//
//  Created by PATRICK PERINI on 8/27/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit

@objc protocol SeatingViewDataSource: NSObjectProtocol {
    func seatingViewNumberOfSeats(seatingView: SeatingView) -> Int
    func seatingView(seatingView: SeatingView, colorForSeatAtIndex seatIndex: Int) -> UIColor
    
    optional func seatingViewAngleOffset(seatingView: SeatingView) -> CGFloat
    optional func seatingView(seatingView: SeatingView, seatIsPushedInAtIndex index: Int) -> Bool
}

@IBDesignable class SeatingView: UIView {
    // MARK: Properties
    @IBOutlet var dataSource: SeatingViewDataSource?
    
    private let centerTableView: RoundView = RoundView()
    private var seatViews: [RoundView] = []
    
    // MARK: Initiailizers
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup
        self.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.centerTableView.backgroundColor = self.tintColor
        self.centerTableView.borderColor = self.backgroundColor
        self.centerTableView.borderWidth = 4.0
        
        self.centerTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(self.centerTableView)
    }
    
    // MARK: Data Handlers
    func reloadData() {
        if let dataSource = self.dataSource {
            let numberOfSeats = dataSource.seatingViewNumberOfSeats(self)
            
            while numberOfSeats < self.seatViews.count {
                self.seatViews.removeLast()
            }
            
            while numberOfSeats > self.seatViews.count {
                self.seatViews.append(RoundView())
            }
            
            self.layoutSeatViews()
        }
    }
    
    private func layoutSeatViews() {
        for (index, seatView) in enumerate(self.seatViews) {
            seatView.backgroundColor = self.dataSource?.seatingView(self, colorForSeatAtIndex: index)
            seatView.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addSubview(seatView)
        }
    }
    
    // MARK: Layout Handlers
    override func layoutSubviews() {
        if self.centerTableView.constraints().isEmpty {
            self.addConstraint(NSLayoutConstraint(item: self.centerTableView,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Width,
                multiplier: 0.50,
                constant: 0.0))
            
            self.addConstraint(NSLayoutConstraint(item: self.centerTableView,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Width,
                multiplier: 0.50,
                constant: 0.0))
            
            self.addConstraint(NSLayoutConstraint(item: self.centerTableView,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterX,
                multiplier: 1.0,
                constant: 0.0))
            
            self.addConstraint(NSLayoutConstraint(item: self.centerTableView,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterY,
                multiplier: 1.0,
                constant: 0.0))
            
            self.centerTableView.layoutIfNeeded()
        }
        
        let seatsCount = CGFloat(self.seatViews.count)
        let seatsSize = CGFloat(min(0.25, 1.0 / seatsCount))
        
        let seatsAngleOffset = self.dataSource?.seatingViewAngleOffset?(self) ?? 0.0
        var seatsAngle = CGFloat((180.0 * (seatsCount - 2)) / seatsCount)
        if seatsAngle == 0 {
            seatsAngle = 90.0
        }
        
        for (index, seatView) in enumerate(self.seatViews) {
            seatView.removeConstraints(seatView.constraints())
            
            self.addConstraint(NSLayoutConstraint(item: seatView,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Width,
                multiplier: seatsSize,
                constant: 0.0))
            
            self.addConstraint(NSLayoutConstraint(item: seatView,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Height,
                multiplier: seatsSize,
                constant: 0.0))

            seatView.layoutIfNeeded()
            
            var radius = self.frame.height - self.centerTableView.center.y - (seatView.frame.height / 2.0)
            if self.dataSource?.seatingView?(self, seatIsPushedInAtIndex: index) ?? false {
                radius /= 1.5
            }
            
            let x = radius * cos(2.0 * CGFloat(M_PI) * CGFloat(index) / seatsCount)
            let y = radius * sin(2.0 * CGFloat(M_PI) * CGFloat(index) / seatsCount)

            self.addConstraint(NSLayoutConstraint(item: seatView,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self.centerTableView,
                attribute: .CenterX,
                multiplier: 1.0,
                constant: x))
            
            self.addConstraint(NSLayoutConstraint(item: seatView,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: self.centerTableView,
                attribute: .CenterY,
                multiplier: 1.0,
                constant: y))
            
            self.sendSubviewToBack(seatView)
            seatView.layoutIfNeeded()
        }
    }
}
