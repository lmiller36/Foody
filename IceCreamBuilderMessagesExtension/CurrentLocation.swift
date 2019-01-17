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
    
    
    private let locationManager = CLLocationManager()
    //radius in meters
    private var radius: Int
    
    
    
    public static var sharedInstance = CurrentLocation.init()
    fileprivate init() {
        // For use in foreground
       self.radius = 500
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func getRadius()->Int{
        return self.radius
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func setRadius(radius:Int){
        self.radius = radius
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     - Parameters:
     - style: The style of the bicycle
     - gearing: The gearing of the bicycle
     - handlebar: The handlebar of the bicycle
     - frameSize: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle,
     custom-built just for you.
     */
    func getCurrentLocation() -> CLLocation?{
        guard let lastLocation = self.locationManager.location else {return Optional<CLLocation>.none}
        return lastLocation
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func lookUpCurrentLocation(callback: @escaping (_ location: CLPlacemark?) -> Void) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
                        
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
