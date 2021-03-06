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
    func seatingView(seatingView: SeatingView, imageForSeatAtIndex seatIndex: Int) -> UIImage

    optional func seatingView(seatingView: SeatingView, seatIsPushedInAtIndex index: Int) -> Bool
}

@objc protocol SeatingViewDelegate: NSObjectProtocol {
    optional func seatingView(seatingView: SeatingView, seatWasTappedAtIndex index: Int)
}

@IBDesignable class SeatingView: UIView {
    // MARK: Types
    private class SeatView: UIImageView {
        // MARK: Properties
        var touchHandler: (SeatView) -> Void = { (_: SeatView) in }
        
        // MARK: Responders
        private override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
            self.touchHandler(self)
        }
    }
    
    // MARK: Properties
    @IBOutlet var dataSource: SeatingViewDataSource?
    @IBOutlet var delegate: SeatingViewDelegate?
    
    private let centerTableView: RoundView = RoundView()
    private var seatViews: [SeatView] = []
    
    // MARK: Initiailizers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup
        self.translatesAutoresizingMaskIntoConstraints = false

        self.centerTableView.backgroundColor = self.backgroundColor
        self.centerTableView.borderColor = self.tintColor
        self.centerTableView.borderWidth = 1.0
        
        self.centerTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.centerTableView)
    }
    
    // MARK: Data Handlers
    func reloadData() {
        for seatView in self.seatViews {
            seatView.touchHandler = { (_: SeatView) in }
            seatView.removeFromSuperview()
        }
        
        self.seatViews = []
        
        if let dataSource = self.dataSource {
            let numberOfSeats = dataSource.seatingViewNumberOfSeats(self)
            while numberOfSeats > self.seatViews.count {
                self.seatViews.append(SeatView())
            }
            
            self.layoutSeatViews()
        }
    }
    
    private func layoutSeatViews() {
        for (index, seatView) in self.seatViews.enumerate() {
            seatView.image = self.dataSource?.seatingView(self, imageForSeatAtIndex: index)
            seatView.tintColor = self.dataSource?.seatingView(self, colorForSeatAtIndex: index)
            
            seatView.translatesAutoresizingMaskIntoConstraints = false
            
            seatView.touchHandler = { [unowned self] (_: SeatView) in
                self.delegate?.seatingView?(self,
                    seatWasTappedAtIndex: index)
            }
            
            self.addSubview(seatView)
        }
    }
    
    // MARK: Layout Handlers
    override func layoutSubviews() {
        if self.centerTableView.constraints.isEmpty {
            self.addConstraint(NSLayoutConstraint(item: self.centerTableView,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Width,
                multiplier: 0.40,
                constant: 0.0))
            
            self.addConstraint(NSLayoutConstraint(item: self.centerTableView,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Width,
                multiplier: 0.40,
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
        
        for (index, seatView) in self.seatViews.enumerate() {
            seatView.removeConstraints(seatView.constraints)
            
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
                radius /= 2.0
            }
            
            let x = radius * cos(2.0 * CGFloat(M_PI) * CGFloat(index) / seatsCount)
            let y = radius * sin(2.0 * CGFloat(M_PI) * CGFloat(index) / seatsCount)
            seatView.transform = CGAffineTransformMakeRotation((2.0 * CGFloat(M_PI) * CGFloat(index) / seatsCount) + CGFloat(M_PI_2))

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
