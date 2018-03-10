//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Mike Haydan on 10/03/2018.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var timestamp: Date?

}
