//
//  Location+CoreDataProperties.swift
//  TripManagement
//
//  Created by Virtual Dusk  on 25/09/21.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var accuracy: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timeStamp: Date?
    @NSManaged public var hasTrip: Trip?

}

extension Location : Identifiable {

}
