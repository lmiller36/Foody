//
//  CurrentLocation.swift
//  IceCreamBuilder
//
//  Created by Lorne on 9/21/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import CoreLocation

class CurrentLocation{
    
    
//    private static
   // let currentLocation = CurrentLocation();
    private let locationManager = CLLocationManager()
    //radius in meters
    private var radius: Int
    public static var sharedInstance = CurrentLocation.init()
    fileprivate init() {
        // For use in foreground
       self.radius = 1000
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func getRadius()->Int{
        return self.radius
    }
    
    func setRadius(radius:Int){
        self.radius = radius
    }
    
    func getCurrentLocation() -> CLLocation?{
        guard let lastLocation = self.locationManager.location else {return Optional<CLLocation>.none}
        return lastLocation
    }
    
    func lookUpCurrentLocation(callback: @escaping (_ location: CLPlacemark?) -> Void) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            print(self.locationManager.location)
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    
                    let firstLocation = placemarks?[0]
                    callback(firstLocation)
                }
                else {
                    print("error geocode1")
                    // An error occurred during geocoding.
                    callback(Optional<CLPlacemark>.none)
                }
            })
        }
        else {
            print("error geocodeq")
            
            // No location was available.
            callback(Optional<CLPlacemark>.none)
        }
    }
}
