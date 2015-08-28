//
//  AppDelegate.swift
//  Tenderloin
//
//  Created by PATRICK PERINI on 8/27/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Class Properties
    static var sharedAppDelegate: AppDelegate? { return UIApplication.sharedApplication().delegate as? AppDelegate }
    
    // MARK: Properties
    var window: UIWindow?
    var locationManager: CLLocationManager?

    // MARK: Lifecycle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Setup Parse
        Parse.setApplicationId("EEzqStxLoKFEo9RtjMo3didnPiJXQDbRW4EPLLdB",
            clientKey: "N1KQmJhqnVem4oCpC2DU8khmJz9n0PDAPGiKA3g6")
        
        Event.registerSubclass()
        
        // Setup Location
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        
        self.locationManager?.requestWhenInUseAuthorization()
        
        return true
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        manager.startMonitoringSignificantLocationChanges()
    }
}

