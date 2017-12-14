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
    
    func trackAnimeLocation(location:String)
    {
        if let region = geofenceForLocation(location: location){
            trackGeofence(geofence: region)
        }
    }
    
    func geofenceForLocation(location:String) -> Geofence?
    {
        return nil
    }
    
    func trackGeofence(geofence:Geofence){
        let region = CLCircularRegion(center: geofence.coordinate, radius: geofence.radius, identifier: geofence.identifier)
        region.notifyOnEntry = true
        locationManager.startMonitoring(for: region)
    }

}

extension LocationManager: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        os_log("%@: Entered region", self.description)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        os_log("%@: Current location: %@, %@", self.description, locValue.latitude.description, locValue.longitude.description)
        manager.location?.locationDictionary { (locationDict) in
            if let state = locationDict["State"] as? String{
                os_log("%@: State: %@", self.description, state)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log("%@: Location monitoring failed: %@", type: .error, self.description, error.localizedDescription)
    }
}

extension CLLocation{
    func locationDictionary(completion:@escaping (_ locationDict:[AnyHashable:Any]) -> Void){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(self) { (placemarks, error) in
            if (error != nil){
                os_log("%@: Error reverse geocode location: %@", type:.error, self.description, error.debugDescription)
                return
            }
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            let locationDict = placeMark.addressDictionary!
            #if DEBUG
                os_log("%@: Placemark dictionar: %@", self.description, locationDict)
            #endif
            
            completion(locationDict)
            
        }
    }
}
