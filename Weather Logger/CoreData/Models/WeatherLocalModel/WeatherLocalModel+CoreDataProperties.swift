//
//  WeatherLocalModel+CoreDataProperties.swift
//  Weather Logger
//
//  Created by Mike Haydan on 13/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherLocalModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherLocalModel> {
        return NSFetchRequest<WeatherLocalModel>(entityName: "WeatherLocalModel")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var dt: Int64
    @NSManaged public var base: String?
    @NSManaged public var visibility: Double
    @NSManaged public var coord: CordsLocal?
    @NSManaged public var weather: NSSet?
    @NSManaged public var main: MainLocal?
    @NSManaged public var wind: WindLocal?
    @NSManaged public var sys: SysLocal?
}

// MARK: Generated accessors for weather
extension WeatherLocalModel {

    @objc(addWeatherObject:)
    @NSManaged public func addToWeather(_ value: WeatherLocal)

    @objc(removeWeatherObject:)
    @NSManaged public func removeFromWeather(_ value: WeatherLocal)

    @objc(addWeather:)
    @NSManaged public func addToWeather(_ values: NSSet)

    @objc(removeWeather:)
    @NSManaged public func removeFromWeather(_ values: NSSet)

}
