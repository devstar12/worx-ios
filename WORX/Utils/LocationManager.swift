//
//  LocationManager.swift
//  JackTag
//
//  Created by Xian Huang on 2/10/20.
//  Copyright © 2020 Xian Huang. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

private var sharedManager: LocationManager? = nil

class LocationManager: NSObject, CLLocationManagerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    static func getSharedManager () -> LocationManager {
        if sharedManager == nil {
            sharedManager = LocationManager()
        }
        return sharedManager!
    }
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        locationManager.requestAlwaysAuthorization()
    }
    func startUpdatingLocation(){
        self.locationManager.startUpdatingHeading()
    }
    func saveLastLocation(){
        if self.currentLocation != nil{
            PrefsManager.setLatitude(val: self.currentLocation.coordinate.latitude)
            PrefsManager.setLongitude(val: self.currentLocation.coordinate.longitude)
            print("Location updated: \(self.currentLocation.coordinate.latitude), \(self.currentLocation.coordinate.longitude)")
        }
        self.locationManager?.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        self.currentLocation = locationArray.lastObject as? CLLocation
        self.saveLastLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldIAllow = false
        switch status {
        case CLAuthorizationStatus.restricted:
            print("Location Manager Status Restricted")
            shouldIAllow = false
        case CLAuthorizationStatus.denied:
            print("Location Manager Status Denined")
            shouldIAllow = false
        case CLAuthorizationStatus.notDetermined:
            print("Location Manager Status Notdetermined")
            shouldIAllow = false
        default:
            print("Location Manager Status OK")
            shouldIAllow = true
        }
        if shouldIAllow == true{
            print("Location Manager started updating location")
            locationManager?.startUpdatingLocation()
            locationManager?.startMonitoringSignificantLocationChanges()
            locationManager?.allowsBackgroundLocationUpdates = true
        }
    }
}
