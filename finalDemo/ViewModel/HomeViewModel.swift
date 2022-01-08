//
//  HomeViewModel.swift
//  finalDemo
//
//  Created by BirTakım Yazılım on 8.01.2022.
//

import SwiftUI
import CoreLocation

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
}
