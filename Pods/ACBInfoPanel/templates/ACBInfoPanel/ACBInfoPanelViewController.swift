//
//  ACBInfoPanelViewController.swift
//  ACBInfoPanel
//
//  Created by PATRICK PERINI on 8/9/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit

public class ACBInfoPanelViewController: UIViewController {
    // MARK: Types
    private enum AvatarTag: Int {
        case Alec = 1
        case Patrick = 2
    }
    
    // MARK: Properties
    public var ingredient: String = "$INGREDIENT"
    @IBOutlet internal var contentLabel: UILabel!
    
    // MARK: Initializers
    public convenience init() {
        self.init(nibName: "ACBInfoPanelViewController", bundle: NSBundle(forClass: self.dynamicType))
    }
    
    // MARK: Lifecycle
    public override func viewDidLoad() {
        self.contentLabel.text = self.contentLabel.text?.stringByReplacingOccurrencesOfString("$INGREDIENT",
            withString: self.ingredient,
            options: NSStringCompareOptions.BackwardsSearch,
            range: nil)
    }
    
    // MARK: Responders
    @IBAction internal func headerWasPressed(sender: UIButton!) {
        UIApplication.sharedApplication().openURL(NSURL.cookbookInfoURL)
    }
    
    @IBAction internal func avatarWasPressed(sender: UIButton!) {
        switch AvatarTag(rawValue: sender.tag)! {
        case .Alec:
            UIApplication.sharedApplication().openURL(NSURL.alecTwitterURL)
            
        case .Patrick:
            UIApplication.sharedApplication().openURL(NSURL.patrickTwitterURL)
            
        default:
            break
        }
    }
    
    @IBAction internal func twitterFooterWasPressed(sender: UIButton!) {
        UIApplication.sharedApplication().openURL(NSURL.cookbookTwitterURL)
    }
    
    @IBAction internal func swipeDownGestureWasRecognized(sender: UIGestureRecognizer!) {
        self.presentingViewController?.dismissViewControllerAnimated(true,
            completion: nil)
    }
}
