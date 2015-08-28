//
//  HomeViewController.swift
//  Tenderloin
//
//  Created by PATRICK PERINI on 8/27/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import GradientView
import ACBInfoPanel

class HomeViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var gradientView: GradientView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.gradientView.colors = [
            UIColor(white: 0.0, alpha: 0.0),
            self.navigationController!.navigationBar.barTintColor!
        ]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let eventListVC = segue.destinationViewController as? EventListViewController {
            eventListVC.homeViewController = self
        } else {
            super.prepareForSegue(segue, sender: sender)
            
            switch segue.identifier {
            case .Some("PushDetail"):
                let event = sender as! Event
                let detailVC = segue.destinationViewController as! EventDetailViewController
                detailVC.event = event
                
            default:
                break
            }
        }
    }
    
    // MARK: Responders
    @IBAction func aboutButtonWasPressed(sender: UIBarButtonItem!) {
        let infoPanel = ACBInfoPanelViewController()
        infoPanel.ingredient = "Food Expiration"
        
        self.presentViewController(infoPanel,
            animated: true,
            completion: nil)
    }
}
