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
