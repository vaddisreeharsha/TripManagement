//
//  ViewController.swift
//  TripManagement
//
//  Created by Virtual Dusk  on 23/09/21.
//

import UIKit
import CoreLocation


class HomeVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var startTripBtn: UIButton!
    
    @IBOutlet weak var stopTripBtn: UIButton!
    
    @IBOutlet weak var currentTripName: UILabel!
    
    
    
    let userDefaults = UserDefaults.standard
    var homeVM = HomeVCViewModel()
    var userLocationManager = UserLocationManger.shared
    let appDelegate  = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeVM.delegate = self
        self.updateButtons(isStarted: homeVM.isTripStarted)
        if homeVM.isTripStarted{
            let status = userLocationManager.getauthorizedStaus()
            if (status == .denied || status == .notDetermined){
                let alert  = UIAlertController(title: "Location Permistion Denied", message: "Pls give permision in settings", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
            }else{
                userLocationManager.stopUpdateLocationManager()
                self.appDelegate?.setUpRepeatingTimer()
            }
        }else{
            userLocationManager.stopUpdateLocationManager()
        }
        
    }
    
    @IBAction func onClickStartBtn(_ sender: UIButton) {
        let status = userLocationManager.getauthorizedStaus()
        if (status == .denied || status == .notDetermined){
            let alert  = UIAlertController(title: "Location Permistion Denied", message: "Pls give permision in settings", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }else{
            alertWithTF(title: "Trip Name :", message: "")
        }
        
        
    }
    
    func startTrip(with tripName : String , tripId : UUID){
        
        userLocationManager.stopUpdateLocationManager()
        userLocationManager.startUpdateLocationManager()
        userLocationManager.isLocationUpdate = false
        self.appDelegate?.setUpRepeatingTimer()
        let tripData = TripData(name: tripName, id: tripId, startTime: Date(), endTime: nil, listOfLocations: nil)
        
        DBManager().createTrip(trip: tripData)
        
        userDefaults.setValue(true, forKey: UserDefaultKeys.isTripStarted)
        userDefaults.setValue(tripName, forKey: UserDefaultKeys.currentTripName)
        userDefaults.setValue(tripId.uuidString, forKey: UserDefaultKeys.currentTripId)
        userDefaults.synchronize()
        if let id = (UserDefaults.standard.value(forKey: UserDefaultKeys.currentTripId) as? String){
            homeVM.currentTripId = UUID(uuidString: id)
        }
        
        homeVM.isTripStarted = true
        homeVM.currentTripId = tripId
        homeVM.currentTripName = tripName
        
    }
    
    @IBAction func onClickStopBtn(_ sender: UIButton) {
        self.appDelegate?.repeatingTimer?.suspend()
        self.appDelegate?.repeatingTimer = nil
        userLocationManager.stopUpdateLocationManager()
        userLocationManager.isLocationUpdate = false
        
        guard let currentLocation = userLocationManager.currentLocation else {
            print("Unable to get current location in Stop")
            return
        }
        
        guard let tripId = userDefaults.value(forKey: UserDefaultKeys.currentTripId) as? String, let tripUUID = UUID(uuidString: tripId) else {
            print("Unable to get tripId from Userdefaults in Stop")
            return}
        
        let locData = LocationData(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, accuracy: currentLocation.horizontalAccuracy, timeStamp: Date())
        
        DBManager().updateTrip(tripId:tripUUID, endTime: Date(), location: locData)
        
        userDefaults.setValue(false, forKey: UserDefaultKeys.isTripStarted)
        userDefaults.setValue(nil, forKey: UserDefaultKeys.currentTripName)
        userDefaults.setValue(nil, forKey: UserDefaultKeys.currentTripId)
        homeVM.isTripStarted = false
        homeVM.currentTripId = nil
        homeVM.currentTripName = ""
        
    }
    
    @IBAction func onTapViewAllTrips(_ sender: UIButton) {
        
        guard let trips = DBManager().getAllTrips() else {return}
        
        for trip in trips{
            debugPrint("Trip name:- \(trip.tripName), id :- \(trip.tripid), st : \(trip.startTime), End :- \(trip.endTime)  TripLocation :- \(trip.haveLocations?.count)")
            
            if let locations = trip.haveLocations{
                for loc in locations.compactMap({ $0 as? Location}){
                    debugPrint("lat - \(loc.latitude), lon - \(loc.longitude), accuracy:- \(loc.accuracy), time :- \(loc.timeStamp)")
                }
            }
            
            debugPrint("************* ------------ *******************")
        }
        let vc = TripsListVC(dbListOfTrips: trips)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func alertWithTF(title : String, message : String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Enter Trip Name"
            textField.delegate = self
        }
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { okAction -> Void in
            if let txtFiledText = alert.textFields?.first?.text, txtFiledText.isEmpty == false {
                let id  = UUID()
                print(" self.startTrip(with: txtFiledText, tripId: UUID())")
                self.startTrip(with: txtFiledText, tripId: id)
                
                print(id)
            }
            
            
        })
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension HomeVC : HomeVCProtocal{
    func updateButtons(isStarted: Bool) {
        self.startTripBtn.isEnabled = !isStarted
        self.stopTripBtn.isEnabled = isStarted
    }
    
    func updateView() {
        self.currentTripName.text = self.homeVM.currentTripName
    }
}
