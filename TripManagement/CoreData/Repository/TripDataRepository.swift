//
//  TripDataRepository.swift
//  TripManagement
//
//  Created by Virtual Dusk  on 24/09/21.
//

import Foundation
import CoreData


struct DBManager{
    
    func createTrip(trip : TripData){
        let ctrip = Trip(context: PersistentStorage.shared.context)
        ctrip.tripid = trip.id
        ctrip.tripName = trip.name
        ctrip.startTime = trip.startTime
        ctrip.endTime = trip.endTime
        ctrip.haveLocations = []//addedLocation(location: location)
        PersistentStorage.shared.saveContext()
    }
    
    fileprivate func addLocation(location : LocationData) -> NSSet{
        
        let cLocation = Location(context: PersistentStorage.shared.context)
        cLocation.longitude = location.longitude
        cLocation.latitude = location.latitude
        cLocation.accuracy = location.accuracy
        cLocation.timeStamp = location.timeStamp
    
        PersistentStorage.shared.saveContext()
        return [cLocation]
    }
    
    func getTripBy(tripId : UUID) -> Trip?{
        let predicate = NSPredicate.init(format: "tripid == %@", tripId as CVarArg)
        let listOfTrips = fetchRecords(objectType: Trip.self, withPredicate: predicate)
        
        
        return listOfTrips?.first
    }
    func getAllTrips() -> [Trip]?{
        let records = PersistentStorage.shared.fetchManagedObject(managedObject: Trip.self)
        guard records != nil,  records?.count != 0 else {
            return nil
        }
        //var result = [TripData]
        
        return records
    }
    
    
    func updateTrip(tripId : UUID, endTime : Date?, location : LocationData){
        guard let cTrip = getTripBy(tripId: tripId) else {return}
        let cLocation = addLocation(location: location)
        cTrip.endTime = endTime
        cTrip.addToHaveLocations(cLocation)
        
        PersistentStorage.shared.saveContext()
        
    }
    
    func createLocation(location : LocationData){
        
        let cLocation = Location(context: PersistentStorage.shared.context)
        cLocation.longitude = location.longitude
        cLocation.latitude = location.latitude
        cLocation.accuracy = location.accuracy
        PersistentStorage.shared.saveContext()
    }
    
    func fetchRecords<T: NSManagedObject>(objectType : T.Type, withPredicate predicate: NSPredicate? = nil ) -> [T]?{
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            guard let result = try PersistentStorage.shared.context.fetch(fetchRequest) as? [T] else { return nil }
            return result
        } catch   {
            print(error)
            
        }
        return nil
        
    }
    
}
