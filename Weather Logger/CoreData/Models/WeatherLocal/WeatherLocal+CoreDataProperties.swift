//
//  WeatherLocal+CoreDataProperties.swift
//  Weather Logger
//
//  Created by Mike Haydan on 13/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherLocal> {
        return NSFetchRequest<WeatherLocal>(entityName: "WeatherLocal")
    }

    @NSManaged public var id: Int64
    @NSManaged public var main: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var icon: String?
    @NSManaged public var weatherLocalModel: WeatherLocalModel?

}
