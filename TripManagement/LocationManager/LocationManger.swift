//
//  LocationManger.swift
//  TripManagement
//
//  Created by Virtual Dusk  on 25/09/21.
//

import Foundation
import CoreLocation



class UserLocationManger : NSObject, CLLocationManagerDelegate{
    
    static let shared = UserLocationManger()
    private let locationManager  = CLLocationManager()
    var currentLocation : CLLocation?
    var isLocationUpdate : Bool = false
    private override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestWhenInUseAuthorization()
        
    }
    func startUpdateLocationManager(){
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
        self.isLocationUpdate = false
    }
    func stopUpdateLocationManager(){
        locationManager.stopUpdatingLocation()
        self.isLocationUpdate = true
    }
    
    func getauthorizedStaus() -> CLAuthorizationStatus{
        self.locationManager.authorizationStatus
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if self.isLocationUpdate {return}
        self.isLocationUpdate = true
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            self.currentLocation = location
            let longitude = location.coordinate.longitude
            let latitude = location.coordinate.latitude
            let accuracy = location.horizontalAccuracy
            let timeStamp = Date()
            print("longitude = \(longitude), latitude = \(latitude), accuracy = \(accuracy), time stamp = \(timeStamp)")
            let location = LocationData(latitude: latitude, longitude: longitude, accuracy: accuracy, timeStamp: timeStamp)
            let userDefaults = UserDefaults.standard
            guard let tripId = userDefaults.value(forKey: UserDefaultKeys.currentTripId) as? String, let tripUUID = UUID(uuidString: tripId) else {
                print("Unable to get tripId from Userdefaults in Stop")
                return}
            DBManager().updateTrip(tripId: tripUUID, endTime: nil, location: location)
            
        }
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidPauseLocationUpdates")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidResumeLocationUpdates")
    }

}
