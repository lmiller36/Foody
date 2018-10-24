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
        
    }
    
    func setupMap(){
        if(!self.hasSetupMap) {
            if let current_location_2dcoordinate=CurrentLocation.sharedInstance.getCurrentLocation()?.coordinate{

                
               // var zoomRect = MKMapRectNull

                
                if let iceCreams = RestaurantsNearby.sharedInstance.getIceCreams() {
                  //  let mapSize = MKMapSize.init(width: 1, height: 1)
                    for iceCream in iceCreams{
                        if let restaurant = iceCream.restaurantInfo {
                            let annotation = RestaurantMarker(restaurant: iceCream)

                          //     let point = MKMapPoint.init(x: restaurant.coordinates.latitude, y: restaurant.coordinates.longitude)

                            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude)
                            annotation.title = restaurant.name
                            //annotation.image

//
//                            var pointRect = MKMapRect.init(origin: point, size: mapSize)
//                            zoomRect = MKMapRectUnion(zoomRect, pointRect)
//
//                            annotationView.image = iceCream.icon?.image
                            self.mapView.addAnnotation(annotation)
                            
                               // }
                        }
                    }
                }
                
                let circle = MKCircle.init(center: current_location_2dcoordinate, radius: CLLocationDistance(CurrentLocation.sharedInstance.getRadius()))

                mapView.addOverlays([circle])
                

                //#TODO Fix to match Currentlocation.radius
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: current_location_2dcoordinate, span: span)
                mapView.setRegion(region, animated: true)
                
             
                
                mapView.showsUserLocation = true
            

            }
            self.hasSetupMap = true
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
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
//    {
//
//        if !(annotation is MKPointAnnotation) {
//            return nil
//        }
//
//        let annotationIdentifier = "AnnotationIdentifier"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//            annotationView!.canShowCallout = true
//        }
//        else {
//            annotationView!.annotation = annotation
//        }
//
//        let originalImage = getType(type: "pizza").image
//        if let cgimage = originalImage.cgImage {
//            //#TODO fix magic number
//            let pinImage = UIImage.init(cgImage: cgimage, scale: 14.0, orientation: originalImage.imageOrientation)
//
//
//            annotationView!.image = pinImage
//        }
//
//
//        return annotationView
//    }
    
    //#TODO you can't jsut steal someone's code
//    func ResizeImage(image: UIImage, targetWidth:Int,targetHeight:Int) -> UIImage? {
//        let size = image.size
//
//        let widthRatio  = targetWidth  / image.size.width
//        let heightRatio = targetHeight / image.size.height
//
//        // Figure out what our orientation is, and use that to form the rectangle
//        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
//        } else {
//            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
//        }
//
//        // This is the rect that we've calculated out and this is what is actually used below
//        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
//
//        // Actually do the resizing to the rect using the ImageContext stuff
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        image.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage
//    }

    @objc func ToggleMap(_ sender: Any) {
        print("dont fail :'(")
        mapView.isHidden = !mapView.isHidden
        self.setupMap()
    }
}

class RestaurantMarker :MKPointAnnotation {
    
    var restaurant : Restaurant
    
    required init(restaurant:Restaurant) {
        self.restaurant = restaurant
        super.init()
    }
    
}
