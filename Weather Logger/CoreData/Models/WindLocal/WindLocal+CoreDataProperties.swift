//
//  WindLocal+CoreDataProperties.swift
//  Weather Logger
//
//  Created by Mike Haydan on 13/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//
//

import Foundation
import CoreData


extension WindLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WindLocal> {
        return NSFetchRequest<WindLocal>(entityName: "WindLocal")
    }

    @NSManaged public var speed: Float
    @NSManaged public var deg: Float
    @NSManaged public var weatherLocalModel: WeatherLocalModel?

}
