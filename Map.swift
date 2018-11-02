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

class Map : UICollectionReusableView,MKMapViewDelegate {
    static let reuseIdentifier = "MapReusableView"
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var hasSetupMap : Bool
    
    required init?(coder aDecoder: NSCoder) {
        self.hasSetupMap = false
        super.init(coder: aDecoder)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ToggleMap), name: Notification.Name(rawValue:"ToggleMap"), object: nil)
        nc.addObserver(self, selector: #selector(RepopulateMap), name: Notification.Name(rawValue:"HideApplicableRestaurants"), object: nil)
        
    }
    
    @objc func RepopulateMap() {
        let restaurants = RestaurantsNearby.sharedInstance.getApplicableRestaurants()
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        for restaurant in restaurants{
            
            let annotation = RestaurantMarker(restaurantInfo: restaurant)
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude)
            annotation.title = restaurant.name

            self.mapView.addAnnotation(annotation)
        }
    }
    
    func drawCircle(){
        
        if let current_location_2dcoordinate=CurrentLocation.sharedInstance.getCurrentLocation()?.coordinate{
            
            
            // var zoomRect = MKMapRectNull
            
            
            
            let circle = MKCircle.init(center: current_location_2dcoordinate, radius: CLLocationDistance(CurrentLocation.sharedInstance.getRadius()))
            
            mapView.addOverlays([circle])
            
            
            //#TODO Fix to match Currentlocation.radius
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: current_location_2dcoordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            
            
            mapView.showsUserLocation = true
            
            
        }
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print(overlay)
        print(overlay.isMember(of: MKCircle.self))
        if overlay.isMember(of: MKCircle.self){
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            //circleRenderer.fillColor = UIColor.tra
            circleRenderer.strokeColor = UIColor.blue
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    @objc func ToggleMap(_ sender: Any) {
        if(!self.hasSetupMap){
            self.hasSetupMap = true
            self.RepopulateMap()
        }
        mapView.isHidden = !mapView.isHidden
        self.drawCircle()
    }
}

class RestaurantMarker :MKPointAnnotation {
    
    var restaurantInfo : RestaurantInfo
    
    required init(restaurantInfo:RestaurantInfo) {
        self.restaurantInfo = restaurantInfo
        super.init()
    }
    
}
