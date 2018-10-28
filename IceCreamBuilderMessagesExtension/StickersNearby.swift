//
//  StickersNearby.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne on 9/21/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import CoreLocation

public var App_Location : CLLocationCoordinate2D?
private var lastKnownLocationInstance : CLLocationCoordinate2D?

func generateNearbyRestaurants(completionHandler:@escaping (_ restaurants: [RestaurantInfo]) -> Void){
    // var iceCreams = [IceCream]()
    print("im generated nearby")

    
    CurrentLocation.sharedInstance.lookUpCurrentLocation(callback: { (location) in
        
        guard let locationCoordinates = location?.location?.coordinate else{
            return
        }
        var reloadFromYelp = true
        print(lastKnownLocationInstance)

        //check if data must be reloaded
        if let lastKnownLocation = lastKnownLocationInstance {

            //Data was already loaded from the given location
            //TODO DETERMINE IF .01 is a good fit
            if(abs(locationCoordinates.latitude - lastKnownLocation.latitude) < 0.01  && abs(locationCoordinates.longitude - lastKnownLocation.longitude) < 0.01){
                reloadFromYelp = false
            }
            
        }
        print("SHOULD RELOAD DATA:\(reloadFromYelp)")
        lastKnownLocationInstance = locationCoordinates
        
        let locationToUse = App_Location ?? locationCoordinates
        App_Location = locationToUse
        print(locationToUse)
        //if(reloadFromYelp) {
            getNearby(coordinates: locationToUse,callback:{ (businesses) in
                completionHandler(businesses.businesses)
            })
//        }
//        else {
//            completionHandler(RestaurantsNearby.sharedInstance.getKnownRestaurants())
//        }
       
    })
    
}
func getType(type:String)->Icon{
    switch type{
    case "newamerican":
        return .american
    case "asianfusion":
        return .asianfusion
    case "tradamerican":
        return .american
    case "bagels":
        return .bagels
    case "bakeries":
        return .bakery
    case "bars":
        return .bars
    case "bbq":
        return .bbq
    case "japacurry":
        return .bento
    case "brazilian":
        return .brazilian
    case "breakfast_brunch":
        return .breakfastBrunch
    case "burgers":
        return .burgers
    case "czech":
        return .czech
    case "cheese":
        return .cheese
    case "chicken_wings":
        return .chickenwings
    case "cocktailbars":
        return .cocktailBars
    case "coffee":
        return .coffee
    case "cafes":
        return .coffee
    case "cuban":
        return .cuban
    case "deli":
        return .deli
    case "delis":
        return .deli
    case "desserts":
        return .desserts
    case "donuts":
        return .donuts
    case "falafel":
        return .falafel
    case "foodstands":
        return .foodstand
    case "foodtrucks":
        return .foodstand
    case "fishnchips":
        return .fishnchips
    case "french":
        return .french
    case "german":
        return .german
    case "gourmet":
        return .gourmet
    case "greek":
        return .greek
    case "hawaiian":
        return .hawaiian
    case "hotdog":
        return .hotdog
    case "icecream":
        return .icecream
    case "italian":
        return .italian
    case "japanese":
        return .japanese
    case "jazzandblues":
        return .jazz
    case "korean":
        return .korean
    case "tacos":
        return .mexican
    case "mediterranean":
        return .mediterranean
    case "mexican":
        return .mexican
    case "pizza":
        return .pizza
    case "ramen":
        return .ramen
    case "russian":
        return .russian
    case "seafood":
        return .seafood
    case "latin":
        return .spanish
    case "spanish":
        return .spanish
    case "steak":
        return .steak
    case "sushi":
        return .sushi
    case "tapas":
        return .tapas
    case "tapasmallplates":
        return .tapas
    case "tea":
        return .tea
    case "thai":
        return .thai
    case "vietnamese":
        return .thai
    case "vegan":
        return .vegetarian
    case "wine_bars":
        return .winebars
    case "chickenshop":
        return .chickenshop
    case "sandwiches":
        return .sandwiches
    case "chinese":
        return .chinese

    default:
        print(type)
        return .american
    }
}
