//
//  TextView.swift
//  Tenderloin
//
//  Created by PATRICK PERINI on 8/27/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit

@IBDesignable class TextField: UITextField {
    // MARK: Properties
    @IBInspectable var textInsets: CGSize = CGSize()
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, self.textInsets.width, self.textInsets.height)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, self.textInsets.width, self.textInsets.height)
    }
}