//
//  LocationManager.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/5/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import CoreLocation
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

}

extension LocationManager: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        os_log("%@: Entered region", self.description)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        os_log("%@: Current location: %@, %@", self.description, locValue.latitude.description, locValue.longitude.description)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log("%@: Location monitoring failed: %@", type: .error, self.description, error.localizedDescription)
    }
}
