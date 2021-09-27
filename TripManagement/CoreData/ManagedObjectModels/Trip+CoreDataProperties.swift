//
//  Trip+CoreDataProperties.swift
//  TripManagement
//
//  Created by Virtual Dusk  on 25/09/21.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var endTime: Date?
    @NSManaged public var startTime: Date?
    @NSManaged public var tripid: UUID?
    @NSManaged public var tripName: String?
    @NSManaged public var haveLocations: NSSet?

}

// MARK: Generated accessors for haveLocations
extension Trip {

    @objc(addHaveLocationsObject:)
    @NSManaged public func addToHaveLocations(_ value: Location)

    @objc(removeHaveLocationsObject:)
    @NSManaged public func removeFromHaveLocations(_ value: Location)

    @objc(addHaveLocations:)
    @NSManaged public func addToHaveLocations(_ values: NSSet)

    @objc(removeHaveLocations:)
    @NSManaged public func removeFromHaveLocations(_ values: NSSet)

}

extension Trip : Identifiable {

}
