//
//  CordsLocal+CoreDataProperties.swift
//  Weather Logger
//
//  Created by Mike Haydan on 13/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//
//

import Foundation
import CoreData


extension CordsLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CordsLocal> {
        return NSFetchRequest<CordsLocal>(entityName: "CordsLocal")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var weatherLocalModel: WeatherLocalModel?

}
