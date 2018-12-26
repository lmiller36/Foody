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

class Map : UICollectionReusableView,MKMapViewDelegate,UIGestureRecognizerDelegate {
    static let reuseIdentifier = "MapReusableView"
    
    @IBOutlet weak var mapView: MKMapView!
    
    var lastDrawnCircleCoordinates : CLLocationCoordinate2D?
    var circle : MKCircle?
    var hasSetupMap : Bool
    var radius = 0.05
    
    required init?(coder aDecoder: NSCoder) {
        self.hasSetupMap = false
        super.init(coder: aDecoder)
        
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ToggleMap), name: Notification.Name(rawValue:"ToggleMap"), object: nil)
        nc.addObserver(self, selector: #selector(RepopulateMap), name: Notification.Name(rawValue:"HideApplicableRestaurants"), object: nil)
        //        nc.addObserver(self, selector: #selector(RepopulateMap), name: Notification.Name(rawValue:"MapTap"), object: nil)
        
    }
    
    //    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
    //
    //    }
    
    @objc func RepopulateMap() {
        let restaurants = RestaurantsNearby.sharedInstance.getApplicableRestaurants()
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        var coordinates = [CLLocationCoordinate2D]()
        
        for restaurant in restaurants{
            
            let annotation = RestaurantMarker(restaurantInfo: restaurant)
            let coordinate = CLLocationCoordinate2D(latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude)
            
            coordinates.append(coordinate)
            
            annotation.coordinate = coordinate
            annotation.title = restaurant.name
            
            self.mapView.addAnnotation(annotation)
        }
        
        let rects = coordinates.map{ (coordinate) -> MKMapRect in
            return MKMapRect.init(origin: MKMapPoint.init(x: coordinate.latitude, y: coordinate.longitude),size: MKMapSize.init())
        }
        
        if(rects.count >= 2) {
       var x = MKMapRectUnion(rects[0], rects[1])
        
        rects.forEach {
            rect in
                x = MKMapRectUnion(x,rect)
        }
        
//        print(rects)
//        print(x)
//            print(x.width + 0.01,x.height + 0.01)
            self.radius = max(x.width + 0.01,x.height + 0.01)

        }
       
        
//        let center = CLLocation(latitude: x.origin.coordinate.latitude,longitude: x.origin.coordinate.longitude)
//        let maxVal = max(x.width + 0.01,x.height + 0.01)
//        let radiusCoordinate = CLLocation(latitude: x.origin.coordinate.latitude + maxVal,longitude: x.origin.coordinate.longitude + maxVal)
//        let distance = center.distance(from: radiusCoordinate)
        
        self.drawCircle()
    }
    
    func drawCircle(){
       // print(App_Location)
        //if let lastDrawnCircleCoordinates = self.lastDrawnCircleCoordinates {
        
        if let current_location_2dcoordinate = App_Location{
            
            if let circle = self.circle {
                self.mapView.remove(circle)
            }
            //   if(!coordinatesEqual(rhs: lastDrawnCircleCoordinates, lhs: current_location_2dcoordinate)) {
            
            
            
                    let center = CLLocation(latitude: current_location_2dcoordinate.latitude,longitude: current_location_2dcoordinate.longitude)
            
                    let radiusCoordinate = CLLocation(latitude:current_location_2dcoordinate.latitude + self.radius,longitude: current_location_2dcoordinate.longitude + self.radius)
                    let distance = center.distance(from: radiusCoordinate)
            
            self.circle = MKCircle.init(center: current_location_2dcoordinate, radius: CLLocationDistance(1000))
            if let circle = self.circle {
                mapView.addOverlays([circle])
            }
            
            
            //#TODO Fix to match Currentlocation.radius
            let span = MKCoordinateSpanMake(self.radius, self.radius)
            let region = MKCoordinateRegion(center: current_location_2dcoordinate, span: span)
            
            mapView.setRegion(region, animated: true)
            
            
            
            mapView.showsUserLocation = true
            
            self.lastDrawnCircleCoordinates = current_location_2dcoordinate
            // }
        }
    }
    
    // }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
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

