//
//  RoundView.swift
//  Tenderloin
//
//  Created by PATRICK PERINI on 8/27/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit

class RoundView: UIView {
    // MARK: Properties
    var borderColor: UIColor? {
        get { return UIColor(CGColor: self.layer.borderColor!) }
        set { self.layer.borderColor = newValue?.CGColor }
    }
    
    var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    // MARK: Layout Handlers
    override func drawRect(rect: CGRect) {
        self.layer.cornerRadius = max(self.frame.width, self.frame.height) / 2.0
        self.layer.masksToBounds = true
        
        super.drawRect(rect)
    }
}
