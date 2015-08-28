//
//  NSURL+ACBUrls.swift
//  ACBInfoPanel
//
//  Created by PATRICK PERINI on 8/9/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import Foundation

public extension NSURL {
    // MARK: Constants
    public static var cookbookInfoURL: NSURL! { return NSURL(string: "http://the.appcookbook.in") }
    
    // Twitter
    public static var cookbookTwitterURL: NSURL! { return NSURL(string: "http://twitter.com/@TheAppCookbook") }
    public static var alecTwitterURL: NSURL! { return NSURL(string: "http://twitter.com/@alecat1008") }
    public static var patrickTwitterURL: NSURL! { return NSURL(string: "http://twitter.com/@pcperini") }
}