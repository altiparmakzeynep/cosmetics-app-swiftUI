//
//  HomeViewModel.swift
//  finalDemo
//
//  Created by BirTakım Yazılım on 8.01.2022.
//

import SwiftUI
import CoreLocation
import Firebase

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
                
                return Item(id: id, itemName: name, itemCost: cost, itemDetails: details, itemImage: image, itemRatings: ratings)
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
}
