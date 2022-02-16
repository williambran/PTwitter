//
//  AppDelegate.swift
//  PlatziTweets
//
//  Created by mac1 on 01/07/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        print("02 se inicializa el conection manager")
        ConnectionManager.sharedInstance.observeReachability()
        
        return true
    }




}

