//
//  MainLocal+CoreDataProperties.swift
//  Weather Logger
//
//  Created by Mike Haydan on 13/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//
//

import Foundation
import CoreData


extension MainLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainLocal> {
        return NSFetchRequest<MainLocal>(entityName: "MainLocal")
    }

    @NSManaged public var temp: Double
    @NSManaged public var pressure: Double
    @NSManaged public var humidity: Double
    @NSManaged public var tempMin: Double
    @NSManaged public var tempMax: Double
    @NSManaged public var weatherLocalModel: WeatherLocalModel?

}
