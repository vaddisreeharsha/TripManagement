//
//  TripsListVM.swift
//  TripManagement
//
//  Created by Virtual Dusk  on 28/09/21.
//

import Foundation

class TripsListVM {
    
    var listOfTrips : [TripData] = []
    init(listOfTripsDB : [Trip]) {
        self.listOfTrips = getListOfTrips(listOfTrips: listOfTripsDB)
    }
    
    func getListOfTrips(listOfTrips : [Trip] ) -> [TripData]{
        var list = [TripData]()
        for trip in listOfTrips {
            guard let tripName = trip.tripName else {continue}
            guard let tripId = trip.tripid else { continue}
            guard let stTime = trip.startTime else {continue}
            guard let endTime = trip.endTime else {continue}
            var tripData = TripData(name: tripName, id: tripId, startTime: stTime, endTime: endTime, listOfLocations: [])
            var locationsData = [LocationData]()
            if let tripLocation = trip.haveLocations{
                for loc in tripLocation.compactMap({ $0 as? Location}){
                    guard let timeStamp = loc.timeStamp else {continue}
                    let location = LocationData(latitude: loc.latitude, longitude: loc.longitude, accuracy: loc.accuracy, timeStamp: timeStamp)
                    locationsData.append(location)
                }
            }
            tripData.listOfLocations = locationsData
            list.append(tripData)
        }
        
        return list
    }
}
