

import SwiftUI
import CoreLocation
import Firebase
import SDWebImageSwiftUI

class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    //fetch user location
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    //location details
    @Published var userLocation: CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false

    //hamburger menu
    @Published var showMenu = false
    
    //Items
    @Published var items: [Item] = []
    //Items for search structure
    @Published var filtered: [Item] = []

    //Cart
    @Published var cartItems: [Cart] = []
    @Published var ordered = false

    
    //location functions
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //check location access
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("unknown")
            self.noLocation = false
            //direct call
            locationManager.requestWhenInUseAuthorization()
            //modifying info.plist
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //read user location ad extract detail
        self.userLocation = locations.last
        self.extractLocation()
        self.login()
    }
    
    func extractLocation(){
        CLGeocoder().reverseGeocodeLocation(self.userLocation){(res, err) in
            
            guard let safeData = res else{return}
            
            var address = ""
            
            //get area and locality name
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            
            self.userAddress = address
        }
    }
    
    //login
    func login(){
        Auth.auth().signInAnonymously{(res, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            print("success = \(res!.user.uid)")
            
            //after login
            self.fetchData()
        }
    }
    
    //fetch items data
    func fetchData(){
        
        let db = Firestore.firestore()
        db.collection("Items").getDocuments {(snap, err) in
            guard let itemData = snap else {return}
            self.items = itemData.documents.compactMap({ (doc) -> Item? in
                
                let id = doc.documentID
                let name = doc.get("itemName") as! String
                let cost = doc.get("itemCost") as! NSNumber
                let ratings = doc.get("itemRatings") as! String
                let image = doc.get("itemImage") as! String
                let details = doc.get("itemDetails") as! String
                let itemShow = doc.get("itemShow") as! Bool

                
                return Item(id: id, itemName: name, itemCost: cost, itemDetails: details, itemImage: image, itemRatings: ratings, itemShow: itemShow)
            })
            self.filtered = self.items
        }
    }
    
    //search
    func searchData(){
       
        withAnimation(.linear) {
            self.filtered = self.items.filter {
                return $0.itemName.lowercased().contains(self.search.lowercased())
            }
        }
    }
    
    //add items to cart
    func addToCart(item: Item) {
        
        //eklenmis mi?
        self.items[getIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
        
        let filterIndex = self.filtered.firstIndex{ (item1) -> Bool in
            
            return item.id == item1.id
        }  ?? 0
        
        //update items array
        self.filtered[filterIndex].isAdded = !item.isAdded
        
        if item.isAdded {
            
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
            return
        }
        //else
        self.cartItems.append(Cart(item: item, quantity: 1))
    }
    
    func getIndex(item: Item, isCartIndex: Bool) ->Int{
        
        let index = self.items.firstIndex { (item1) -> Bool in
            
            return item.id == item1.id
            
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex { (item1) -> Bool in
            
            return item.id == item1.item.id
            
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    }
    
    func calculateTotalPrice() -> String {
        
        var price: Float = 0
        
        cartItems.forEach {(item) in
            price += Float(item.quantity) * Float(truncating: item.item.itemCost)
        }
        
        return getPrice(value: price)
    }
    
    func getPrice(value: Float) -> String {
        
        let format = NumberFormatter()
        format.numberStyle = .currency
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    
    //order data to firebase
    func updateOrder() {
        
        let db = Firestore.firestore()
        
        //create dict of food details
        if ordered {
            
            ordered = false
            db.collection("Users").document(Auth.auth().currentUser!.uid).delete {
                (err) in
                if err != nil {
                    self.ordered = true
                }
            }
            return
        }
        var details: [[String: Any]] = []
        
        cartItems.forEach { (cart) in
            details.append([
            
                "itemName": cart.item.itemName,
                "itemQuantity": cart.quantity,
                "itemCost": cart.item.itemCost

            ])
        }
        
        ordered = true
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            
            "orderedFood": details,
            "totalCost": calculateTotalPrice(),
            "location": GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
        ]){ (err) in
            if err != nil {
                self.ordered = false
                return
            }
            print("success")
        }
    }
}
