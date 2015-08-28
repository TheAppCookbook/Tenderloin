//
//  LoginViewController.swift
//  Tenderloin
//
//  Created by PATRICK PERINI on 8/27/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import Parse
import GradientView

class LoginViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var gradientView: GradientView!
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradientView.colors = [
            UIColor.clearColor(),
            self.view.backgroundColor!
        ]
    }
    
    // MARK: Responders
    @IBAction func signInButtonWasPressed(sender: UIButton!) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        let completion = {
            self.presentingViewController?.dismissViewControllerAnimated(true,
                completion: nil)
        }

        PFUser.logInWithUsernameInBackground(newUser.username!, password: newUser.password!) { (user: PFUser?, error: NSError?) in
            if user == nil {
                newUser.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                    if success {
                        completion()
                    }
                })
            } else {
                completion()
            }
        }
    }
}
