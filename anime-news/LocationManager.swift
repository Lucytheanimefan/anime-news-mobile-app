//
//  LocationManager.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/5/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit
import os.log

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func requestPermissions(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func reload(){
        locationManager.requestLocation()
    }
    
    func nameForLocation(location:CLLocation){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if (error != nil){
                os_log("%@: Error reverse geocode location: %@", type:.error, self.description, error.debugDescription)
                return
            }
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if let locationCity = placeMark.addressDictionary!["City"] as? String{
                os_log("%@: Location city: %@", self.description, locationCity)
            }
        }
    }

}

extension LocationManager: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        os_log("%@: Entered region", self.description)
        nameForLocation(location: manager.location!)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        os_log("%@: Current location: %@, %@", self.description, locValue.latitude.description, locValue.longitude.description)
        nameForLocation(location: manager.location!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log("%@: Location monitoring failed: %@", type: .error, self.description, error.localizedDescription)
    }
}
