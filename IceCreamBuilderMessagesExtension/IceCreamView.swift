/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A `UIStackView` containing the parts of a given `IceCream`.
*/

import UIKit

class IceCreamView: UIStackView {
    
    var iceCream: Restaurant? {
        didSet {
            // Remove any existing arranged subviews.
            for view in arrangedSubviews {
                removeArrangedSubview(view)
            }
            
            // Do nothing more if the `iceCream` property is nil.
            guard let unwrappedRestaurantIcon = iceCream else { return }
            
            // Add a `UIImageView` for each of the ice cream's valid parts.
//            let iceCreamParts: [IceCreamPart?] = [unwrappedIceCream.topping, unwrappedIceCream.scoops, unwrappedIceCream.base]
//            for iceCreamPart in iceCreamParts {
//                guard let iceCreamPart = iceCreamPart else { continue }
//
            if let image = unwrappedRestaurantIcon.icon?.image {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                addArrangedSubview(imageView)
            }
        
        }
    }
    
}
