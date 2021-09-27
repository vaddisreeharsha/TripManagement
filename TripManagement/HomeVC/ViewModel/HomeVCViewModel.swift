//
//  HomeVCViewModel.swift
//  TripManagement
//
//  Created by Virtual Dusk  on 24/09/21.
//

import Foundation

protocol HomeVCProtocal {
    func updateButtons(isStarted : Bool)
    func updateView()
}

class HomeVCViewModel {
    
    let userDefaults = UserDefaults.standard
    var delegate : HomeVCProtocal?
    
    var isTripStarted : Bool = UserDefaults.standard.bool(forKey: UserDefaultKeys.isTripStarted) {
        didSet{
            self.delegate?.updateButtons(isStarted: isTripStarted)
        }
    }
    var currentTripId : UUID? 
    var currentTripName : String? = UserDefaults.standard.value(forKey: UserDefaultKeys.currentTripName) as? String{
        didSet{
            self.delegate?.updateView()
        }
    }

}

