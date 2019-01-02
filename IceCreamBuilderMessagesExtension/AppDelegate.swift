//
//  AppDelegate.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreLocation
import SCSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return SCSDKLoginClient.application(app, open: url, options: options)
    }
    
    
}

