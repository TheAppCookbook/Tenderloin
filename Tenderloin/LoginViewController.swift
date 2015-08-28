//
//  LoginViewController.swift
//  Tenderloin
//
//  Created by PATRICK PERINI on 8/27/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
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
