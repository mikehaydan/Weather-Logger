//
//  WeatherLocalModel+CoreDataClass.swift
//  Weather Logger
//
//  Created by Mike Haydan on 13/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//
//

import Foundation
import CoreData

public class WeatherLocalModel: NSManagedObject {
    
    func weatherModel() throws -> WeatherModel {
        let weatherModelParameters = WeatherModelParameters(id: Int(id), name: name!, dt: Int(dt), base: base!, visibility: visibility)
        guard let cords = coord  else {
            throw CoreDataError(message: "Not posiable to configure coord data")
        }
        let cordsParameters = CordsParameters(longitude: cords.longitude, latitude: cords.latitude)
        guard let weather = weather, let weatherArray = weather.allObjects as? [WeatherLocal]  else {
            throw CoreDataError(message: "Not posiable to configure weather data")
        }
        let weatherParameters: [WeatherParameters] = weatherArray.map({ WeatherParameters(id: Int($0.id), main: $0.main!, descriptionText: $0.descriptionText!, icon: $0.icon!) })
        guard let main = main  else {
            throw CoreDataError(message: "Not posiable to configure main data")
        }
        let mainParameters = MainParameters(temp: main.temp, pressure: main.pressure, humidity: main.humidity, tempMin: main.tempMin, tempMax: main.tempMax)
        guard let wind = wind else {
            throw CoreDataError(message: "Not posiable to configure main data")
        }
        let windParameters = WindParameters(speed: wind.speed, deg: wind.deg)
        guard let sys = sys else {
            throw CoreDataError(message: "Not posiable to configure sys data")
        }
        let sysParameters = SysParameters(id: Int(sys.id), type: Int(sys.type), message: sys.message, country: sys.country!, sunrise: sys.sunrise, sunset: sys.sunset)
        
        let weatherModel = WeatherModel(weatherModelParameters: weatherModelParameters, cordsParameters: cordsParameters, weatherParameters: weatherParameters, mainParameters: mainParameters, windParameters: windParameters, sysParameters: sysParameters)
        return weatherModel
    }
    
    func set(model: WeatherModel) throws {
        if let context = self.managedObjectContext {
            id = Int64(model.id)
            name = model.name
            dt = Int64(model.dt)
            base = model.base
            visibility = model.visibility ?? -1
            if let coordsModel = context.addEntity(withType: CordsLocal.self) {
                coordsModel.longitude = model.coord.longitude
                coordsModel.latitude = model.coord.latitude
                self.coord = coordsModel
            } else {
                throw CoreDataError(message: "Not posiable to save coord")
            }
            for weatherItem in model.weather {
                var weatherSet: Set<WeatherLocal> = []
                if let weatherModel = context.addEntity(withType: WeatherLocal.self) {
                    weatherModel.id = Int64(weatherItem.id)
                    weatherModel.main = weatherItem.main
                    weatherModel.descriptionText = weatherItem.descriptionText
                    weatherModel.icon = weatherItem.icon
                    weatherSet.insert(weatherModel)
                } else {
                    throw CoreDataError(message: "Not posiable to save weather")
                }
                weather = weatherSet as NSSet
            }
            if let mainModel = context.addEntity(withType: MainLocal.self) {
                mainModel.temp = model.main.temp
                mainModel.pressure = model.main.pressure
                mainModel.tempMin = model.main.tempMin
                mainModel.tempMax = model.main.tempMax
                main = mainModel
            } else {
                throw CoreDataError(message: "Not posiable to save main info")
            }
            if let windModel = context.addEntity(withType: WindLocal.self) {
                windModel.deg = model.wind.deg
                windModel.speed = model.wind.speed
                wind = windModel
            } else {
                throw CoreDataError(message: "Not posiable to save wind data")
            }
            if let sysModel = context.addEntity(withType: SysLocal.self) {
                sysModel.country = model.sys.country
                let idValue = model.sys.id ?? -1
                sysModel.id = Int64(idValue)
                sysModel.message = model.sys.message
                sysModel.sunrise = model.sys.sunrise
                sysModel.sunset = model.sys.sunset
                let typeValue = model.sys.type ?? -1
                sysModel.type = Int32(typeValue)
                sys = sysModel
            } else {
                throw CoreDataError(message: "Not posiable to save sys data")
            }
        } else {
            throw CoreDataError(message: "Not posiable to save weather")
        }
    }
   
}
