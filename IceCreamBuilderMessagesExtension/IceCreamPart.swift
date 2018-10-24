/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The protocol and enums that define the different types of body parts that are used to build a robot.
*/

import UIKit

protocol IceCreamPart {
    
    var rawValue: String { get }
    
    var image: UIImage { get }
    
    var stickerImage: UIImage { get }

}

//enum Topping: String, IceCreamPart, QueryItemRepresentable {
//
//    case topping01, topping02, topping03, topping04, topping05, topping06, topping07, topping08, topping09, topping10, topping11, topping12
//
//    static let all: [Topping] = [
//        .topping01,
//        .topping02,
//        .topping03,
//        .topping04,
//        .topping05,
//        .topping06,
//        .topping07,
//        .topping08,
//        .topping09,
//        .topping10,
//        .topping11,
//        .topping12
//    ]
//
//    static var queryItemKey: String {
//        return "Topping"
//    }
//
//}

//enum Scoops: String, IceCreamPart, QueryItemRepresentable {
//
//    case scoops01, scoops02, scoops03, scoops04, scoops05, scoops06, scoops07, scoops08, scoops09, scoops10
//
//    static let all: [Scoops] = [
//        .scoops01,
//        .scoops02,
//        .scoops03,
//        .scoops04,
//        .scoops05,
//        .scoops06,
//        .scoops07,
//        .scoops08,
//        .scoops09,
//        .scoops10
//    ]
//
//    static var queryItemKey: String {
//        return "Scoops"
//    }
//
//}

enum Icon: String, IceCreamPart, QueryItemRepresentable {

    case pizza, burger, burgers, mexican, base01, breakfastBrunch, vegetarian, coffee, bars, cocktailBars, sushi, greek, cheese,italian,steak,bakery,icecream,american,french,ramen,russian,asianfusion,japanese,fishnchips,donuts,winebars,seafood,tapas,bbq,hotdog,spanish,jazz,czech,brazilian,gourmet,bagels,desserts,chickenwings,foodstand,korean,hawaiian,bento,cuban,mediterranean,german,thai,falafel,deli,tea,chickenshop,sandwiches,chinese
    static let all: [Icon] = [.pizza,.burger,.burgers,.mexican,.breakfastBrunch,.vegetarian,.coffee,.bars,.cocktailBars,.sushi,.base01,.greek,.cheese,.italian,.steak,.bakery,.icecream,.american,.french,.ramen,.russian,.asianfusion,.japanese,.fishnchips,.donuts,.seafood,.tapas,.bbq,.hotdog,.spanish,.jazz,.czech,.brazilian,.gourmet,.bagels,.desserts,.chickenwings,.foodstand,.korean,.hawaiian,.bento,.cuban,.mediterranean,.german,.thai,.falafel,.deli,.tea,.chickenshop,.sandwiches,.chinese]
    
    static var queryItemKey: String {
        return "Icon"
    }

}

/// Extends `IceCreamPart` to provide a default implementation of the `image` and `stickerImage` properties.

extension IceCreamPart {
    var image: UIImage {
        let imageName = "\(self.rawValue)_sticker"
        guard let image = UIImage(named: imageName) else { fatalError("Unable to find image named \(imageName)") }
        return image
    }
    
    var stickerImage: UIImage {
        let imageName = "\(self.rawValue)_sticker"
        guard let image = UIImage(named: imageName) else { fatalError("Unable to find image named \(imageName)") }
        return image
    }
}

/// Extends instances of `QueryItemRepresentable` that also conformt to `IceCreamPart` to provide a default implementation of `queryItem`.

extension QueryItemRepresentable where Self: IceCreamPart {
    var queryItem: URLQueryItem {
        return URLQueryItem(name: Self.queryItemKey, value: rawValue)
    }

}
