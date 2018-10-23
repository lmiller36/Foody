/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A `UICollectionViewCell` subclass used to display an `IceCream` in the `IceCreamsViewController`.
*/

import UIKit
import Messages

class InitialSelectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "IceCreamCell"
    
    var representedIceCream: IceCream?
    

    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var stickerView: MSStickerView!
    @IBOutlet weak var cellInfo: UILabel!
    
    @IBOutlet weak var statement1: UILabel!
    @IBOutlet weak var statement2: UILabel!
    @IBOutlet weak var statement3: UILabel!
    
}
