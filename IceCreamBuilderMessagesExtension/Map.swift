//
//  Map.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 10/22/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

import UIKit
import MapKit

class Map : UICollectionReusableView {
    static let reuseIdentifier = "MapReusableView"
    
    @IBOutlet weak var mapView: MKMapView!
    
    var hasSetupMap : Bool
    
    required init?(coder aDecoder: NSCoder) {
        self.hasSetupMap = false
        super.init(coder: aDecoder)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ToggleMap), name: Notification.Name(rawValue:"ToggleMap"), object: nil)
        
    }
    
    func setupMap(){
        if(!self.hasSetupMap) {
            if let current_location_2dcoordinate=CurrentLocation.sharedInstance.getCurrentLocation()?.coordinate{
                print("yo")
                print(current_location_2dcoordinate)
            
               // var zoomRect = MKMapRectNull

                
                if let iceCreams = RestaurantsNearby.sharedInstance.getIceCreams() {
                  //  let mapSize = MKMapSize.init(width: 1, height: 1)
                    for iceCream in iceCreams{
                        if let restaurant = iceCream.restaraunt {
                            let annotation = MKPointAnnotation()
                            
                          //     let point = MKMapPoint.init(x: restaurant.coordinates.latitude, y: restaurant.coordinates.longitude)
                            
                            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude)
                            
                         
//
//                            var pointRect = MKMapRect.init(origin: point, size: mapSize)
//                            zoomRect = MKMapRectUnion(zoomRect, pointRect)
                            
//                            DispatchQueue.main.async {
                                self.mapView.addAnnotation(annotation)
                               // }
                        }
                    }
                }
                
                //#TODO Fix to match Currentlocation.radius
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: current_location_2dcoordinate, span: span)
                mapView.setRegion(region, animated: true)
                
                
                
                mapView.showsUserLocation = true

            }
            self.hasSetupMap = true
        }
        
    }
    
    @objc func ToggleMap(_ sender: Any) {
        print("dont fail :'(")
        mapView.isHidden = !mapView.isHidden
        self.setupMap()
    }
}
