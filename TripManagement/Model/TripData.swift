//
//  TripData.swift
//  TripManagement
//
//  Created by Virtual Dusk  on 24/09/21.
//

import Foundation

struct TripData {
    let name : String
    let id : UUID
    let startTime : Date
    let endTime : Date?
    var listOfLocations : [LocationData]?
    
}

struct LocationData {
    let latitude, longitude : Double
    let accuracy: Double
    let timeStamp : Date
}
