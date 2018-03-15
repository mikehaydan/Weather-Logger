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

extension WeatherLocalModel {
    
    func weatherModel() throws -> WeatherApiModel {
        let weatherModelParameters = WeatherModelParameters(id: Int(id), name: name!, dt: Int(dt), base: base!, visibility: visibility)
        guard let cords = coord  else {
            throw NSError.parseError
        }
        let cordsParameters = CordsParameters(longitude: cords.longitude, latitude: cords.latitude)
        guard let weather = weather, let weatherArray = weather.allObjects as? [WeatherLocal]  else {
            throw NSError.parseError
        }
        let weatherParameters: [WeatherParameters] = weatherArray.map({ WeatherParameters(id: Int($0.id), main: $0.main!, descriptionText: $0.descriptionText!, icon: $0.icon!) })
        guard let main = main  else {
            throw NSError.parseError
        }
        let mainParameters = MainParameters(temp: main.temp, pressure: main.pressure, humidity: main.humidity, tempMin: main.tempMin, tempMax: main.tempMax)
        guard let wind = wind else {
            throw NSError.parseError
        }
        let windParameters = WindParameters(speed: wind.speed, deg: wind.deg)
        guard let sys = sys else {
            throw NSError.parseError
        }
        let sysParameters = SysParameters(id: Int(sys.id), type: Int(sys.type), message: sys.message, country: sys.country!, sunrise: sys.sunrise, sunset: sys.sunset)
        
        let weatherModel = WeatherApiModel(weatherModelParameters: weatherModelParameters, cordsParameters: cordsParameters, weatherParameters: weatherParameters, mainParameters: mainParameters, windParameters: windParameters, sysParameters: sysParameters)
        return weatherModel
    }
}
