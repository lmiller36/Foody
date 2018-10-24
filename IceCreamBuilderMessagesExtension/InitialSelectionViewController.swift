/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A `UICollectionViewController` that displays the history of ice creams as well as a cell
 that can be tapped to start the process of creating a new ice cream.
 */

import UIKit
import Messages

class InitialSelectionViewController: UICollectionViewController {
    
    /// An enumeration that represents an item in the collection view.
    
    
    enum CollectionViewItem {
        case iceCream(Restaurant)
        case create
    }
    
    // MARK: Properties
    
    fileprivate let itemsPerRow: CGFloat = 1
    
    static let storyboardIdentifier = "IceCreamsViewController"
    
    private var showDetails=true;
    
    weak var delegate: IceCreamsViewControllerDelegate?
    
    private var items: [CollectionViewItem]
    private var showMap : Bool
    
   
    // private var restaurantsNearby: RestaurantsNearby
    
    private let stickerCache = IceCreamStickerCache.cache
    
   // private var selectedRestaurants : [IceCream]
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        // Map the previously completed ice creams to an array of `CollectionViewItem`s.
        //let reversedHistory =
        
        let reversedHistory = IceCreamHistory.load().reversed()
        var items: [CollectionViewItem] = reversedHistory.map { .iceCream($0) }
        
        // Add `CollectionViewItem` that the user can tap to start building a new ice cream.
        // Add new ice cream
        //         items.insert(.create, at: 0)
        
        self.items = items
        self.showMap = false
        //self.restaurantsNearby = RestaurantsNearby.sharedInstance
        //self.selectedRestaurants = [IceCream]()
        super.init(coder: aDecoder)
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: InitialSelectionHeader.reuseIdentifier, for: indexPath) 
            // do any programmatic customization, if any, here
            
            return view
        }
        else if kind == UICollectionElementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Map.reuseIdentifier, for: indexPath)
            // do any programmatic customization, if any, here
            
            return view
        }
        fatalError("Unexpected kind")
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        
        // The item's type determines which type of cell to return.
        switch item {
        case .iceCream(let iceCream):
            return dequeueIceCreamCell(for: iceCream, at: indexPath)
            
        case .create:
            return dequeueIceCreamAddCell(at: indexPath)
        }
    }
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        let item = items[indexPath.row]
        
        switch item {
        case .create:
            delegate?.iceCreamsViewControllerDidSelectAdd(self)
            
        default:
            break
        }
    }
    
    @IBAction func expandedViewSwitchChanged(_ sender: Any) {
        
        guard let expandedSwitch = sender as? UISwitch else{return;}
        changeExpandedView(shouldShowExpandedView: expandedSwitch.isOn);
    }
    
    func changeExpandedView(shouldShowExpandedView:Bool){
        self.showDetails = shouldShowExpandedView;
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.viewWillAppear(true)
        }
  
    }
    
    
    // MARK: Convenience
    
    private func dequeueIceCreamCell(for iceCream: Restaurant, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: InitialSelectionCell.reuseIdentifier,
                                                             for: indexPath) as? InitialSelectionCell
            else { fatalError("Unable to dequeue am IceCreamCell") }
        
        
        cell.representedIceCream = iceCream
        
        // Use a placeholder sticker while we fetch the real one from the cache.
        let cache = IceCreamStickerCache.cache
        cell.stickerView.sticker = cache.placeholderSticker
        
        guard let restaraunt = iceCream.restaurantInfo else {return cell}
        let restarauntName = restaraunt.name
        guard let price = restaraunt.price else {return cell}
        let rating = restaraunt.rating
        let category = restaraunt.categories[0].title
        let address = restaraunt.location.address1
        let distance =  Measurement(value: restaraunt.distance, unit: UnitLength.meters).converted(to: UnitLength.miles).value
        
        
        cell.labelView.textAlignment = NSTextAlignment.center
        cell.labelView.text = self.showDetails ? category : restarauntName
        
        
        let forceTouchGestureRecognizer = ForceTouchGestureRecognizer(target: self, action: #selector(forceTouchHandler))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        cell.addGestureRecognizer(tap)
        cell.addGestureRecognizer(forceTouchGestureRecognizer)
        
        cell.isUserInteractionEnabled = true
        cell.cellInfo.text = restarauntName;
        cell.statement1.text = (address);
        cell.statement2.text = String(format: "%.1f", distance)+" miles"
        //85bb65
        //cell.statement3.textColor = UIColor.init(displayP3Red: 133, green: 187, blue: 101, alpha: 1.0)
        let bottomLine = "\(RestaurantsNearby.getRatingInStars(rating: restaraunt.rating)) "+price
        let textColor = UIColor.init(red: 133/255, green: 187/255, blue: 101/255, alpha: 1.0)
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: bottomLine)
        attributedString.setColor(color: textColor, forText: price)
        cell.statement3.attributedText = attributedString
        cell.layer.borderWidth = CGFloat(RestaurantsNearby.sharedInstance.getRowStatus(row: indexPath.row))
        cell.layer.borderColor = UIColor.black.cgColor

        
        //        cell.statement3.text =
        
        // Fetch the sticker for the ice cream from the cache.
        cache.sticker(for: iceCream) { sticker in
            OperationQueue.main.addOperation {
                // If the cell is still showing the same ice cream, update its sticker view.
                guard cell.representedIceCream?.icon == iceCream.icon else { return }
                cell.stickerView.sticker = sticker
            }
        }
        
        return cell
    }
    
    @objc private func tapped(_ sender: UITapGestureRecognizer){
        
        guard let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) else {return}
        guard let iceCreamCell = self.collectionView?.cellForItem(at: indexPath) as? InitialSelectionCell else {return}
        guard let selectedIceCream = iceCreamCell.representedIceCream else {return}
        
        //self.selectedRestaurants.append(selectedIceCream)
//        RestaurantsNearby.sharedInstance.addSelectedRestaurant(restaurant: selectedIceCream.restaraunt ?? default )
        if let selectedRestaurant = selectedIceCream.restaurantInfo {
            RestaurantsNearby.sharedInstance.toggleTappedRestaurant(row: indexPath.row)
        }
        
       
        iceCreamCell.layer.borderWidth = CGFloat(RestaurantsNearby.sharedInstance.getRowStatus(row: indexPath.row))
        
        for restaurant in RestaurantsNearby.sharedInstance.getSelectedRestaurant()
        {
            print(restaurant.name)
        }
        
        
        
    }
    @objc private func forceTouchHandler(_ sender: UITapGestureRecognizer){
        
//        guard let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) else {return}
//        guard let iceCreamCell = self.collectionView?.cellForItem(at: indexPath) as? InitialSelectionCell else {return}
//        guard let selectedIceCream = iceCreamCell.representedIceCream else {return}
//      //  let nearbyRestaurants = self.restaurantsNearby.getIceCreams() ?? [IceCream]()
//        print("Force touch triggered")
//
//         let selectedRestaurants = RestaurantsNearby.sharedInstance.getSelectedRestaurant()
//        // 5 is an arbitrary number
//         let extraneousCount = selectedRestaurants.count - 5
//        if(extraneousCount > 0){
//            let alert = UIAlertController(title: "Up to 5 suggestions are alloted per person", message: "Please remove at least \(extraneousCount) \(extraneousCount == 1 ? "item":"items")", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//
//
//            self.present(alert, animated: true)
//        }
//        else {
//        delegate?.addMessageToConversation(selectedRestaurants,messageImage: selectedIceCream)
//        }
        
        print("force touch!")
        
    }
    
    
    private func dequeueIceCreamAddCell(at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: InitialSelectionAddCell.reuseIdentifier,
                                                             for: indexPath) as? InitialSelectionAddCell
            else { fatalError("Unable to dequeue a IceCreamAddCell") }
        return cell
    }
    
    
    override func viewDidLoad() {
        
        generateNearbyRestaurants(completionHandler: { (restaurants) in
            RestaurantsNearby.sharedInstance.add(restaurants: restaurants)
            guard let iceCreams = RestaurantsNearby.sharedInstance.getIceCreams() else{return}
            var newItems: [CollectionViewItem] = iceCreams.map { .iceCream($0) }
            var i = 0;
           // self.items.removeAll()
            for _ in iceCreams{
                self.items.append(newItems[i])
                i=i+1
            }
            
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("DataFetched"), object: nil)
            nc.post(name: Notification.Name("ToggleMapButton"), object: nil)
            print("posted")
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.viewWillAppear(true)
            }
            
            
     
            
  
         
            
        })
        
        
    }
    
    @IBAction func GoBackToMainMenu(_ sender: UIGestureRecognizer) {
        delegate?.backToMainMenu()
    }
    
    
    @IBAction func handleExpandedChange(_ sender: Any) {
        if let expandedSwitch = sender as? UISwitch {
            print(expandedSwitch.isOn)
        }
        
    }
    
    @IBAction func ToggleCollectionView(_ sender: Any) {
        print("xpand map!")
        self.showMap = !self.showMap
        self.items.removeAll()
        
        if(!self.showMap) {
            
            guard let iceCreams = RestaurantsNearby.sharedInstance.getIceCreams() else{return}
            var newItems: [CollectionViewItem] = iceCreams.map { .iceCream($0) }
            var i = 0;
            // self.items.removeAll()
            for _ in iceCreams{
                self.items.append(newItems[i])
                i=i+1
            }
            
        }
        
        
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("ToggleMap"), object: nil)
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.viewWillAppear(true)
        }
        
        //collectionView?.isHidden = true
    }
    @IBAction func SubmitSelection(_ sender: Any) {
//        guard let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) else {return}
//        guard let iceCreamCell = self.collectionView?.cellForItem(at: indexPath) as? InitialSelectionCell else {return}
//        guard let selectedIceCream = iceCreamCell.representedIceCream else {return}
//        //  let nearbyRestaurants = self.restaurantsNearby.getIceCreams() ?? [IceCream]()
//        print("Force touch triggered")
        
        let selectedRestaurants = RestaurantsNearby.sharedInstance.getSelectedRestaurant()
        // 5 is an arbitrary number
        let extraneousCount = selectedRestaurants.count - 4
        
        //TODO Ensure that this works
        if(selectedRestaurants.count == 0){
            let alert = UIAlertController(title: "At least 1 suggestions must be given",message:"Please add at least 1 item", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
        }
       else if(extraneousCount > 0){
            let alert = UIAlertController(title: "Up to 4 suggestions are alloted per person", message: "Please remove at least \(extraneousCount) \(extraneousCount == 1 ? "item":"items")", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
        }
        
        else {
            
            let selectedIceCream = Restaurant(restaurant:selectedRestaurants[0],blackAndWhite:false)
            delegate?.changePresentationStyle(presentationStyle: .compact)
            delegate?.addMessageToConversation(selectedRestaurants,messageImage: selectedIceCream)
        }
    }
    
    
    
    @IBAction func handleSort(_ sender: UISegmentedControl) {
        
        print("selected: \(sender.selectedSegmentIndex)")
        
        switch sender.selectedSegmentIndex {
        case 0:
            RestaurantsNearby.sharedInstance.sort(sortCriteria: RestaurantsNearby.SortCriteria.Distance)
        case 1:
            RestaurantsNearby.sharedInstance.sort(sortCriteria: RestaurantsNearby.SortCriteria.Price)
        case 2:
            RestaurantsNearby.sharedInstance.sort(sortCriteria: RestaurantsNearby.SortCriteria.Rating)
        default:
            print("Not a valid segmented index")
            return
        }
        self.items.removeAll()
        guard let iceCreams = RestaurantsNearby.sharedInstance.getIceCreams() else{return}
        var newItems: [CollectionViewItem] = iceCreams.map { .iceCream($0) }
        //       self.restaurantsNearby.printPrice()
        //newItems.insert(.create, at: 50)
        
        var i=0
        for _ in iceCreams{
            self.items.append(newItems[i])
            i=i+1
        }
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.viewWillAppear(true)
        }
        
        
    }
    
    
    
    
}

extension InitialSelectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(showDetails){
            return CGSize(width: 350, height: 100)
        }
        else{
            return CGSize(width: 75, height: 100
            )
        }
    }
    
}

extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
    
}


// A delegate protocol for the `IceCreamsViewController` class

protocol IceCreamsViewControllerDelegate: class {
    
    /// Called when a user choses to add a new `IceCream` in the `IceCreamsViewController`.
    
    func iceCreamsViewControllerDidSelectAdd(_ controller: InitialSelectionViewController)
    
    func backToMainMenu()
    
    func addMessageToConversation(_ restaurants:[RestaurantInfo],messageImage:Restaurant)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)

}

//extension IceCreamsViewController: SelectedRestaurantControllerDelegate {
//    
//    func iceCreamsViewControllerDidSelectAdd(_ controller: IceCreamsViewController) {
//        print("clicked1")
//        requestPresentationStyle(.expanded)
//    }
//}


