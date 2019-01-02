/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The application delegate.
 */

import UIKit
import CoreLocation
import SCSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("trying!")
        return SCSDKLoginClient.application(app, open: url, options: options)
    }
    
}

