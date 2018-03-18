//
//  WeatherApiModel.swift
//  Weather Logger
//
//  Created by Mike Haydan on 10/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

class WeatherApiModel: InitializableWithData, InitializableWithJson, Codable {
    let id: Int
    let name: String
    let dt: Int
    let base: String
    let visibility: Double?
    let coord: Cords
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let sys: Sys
    var coreDataModel: WeatherLocalModel? = nil
    
    required init(data: Data?) throws {
        if let data = data {
            let jsonDecoder = JSONDecoder()
            do {
                let model = try jsonDecoder.decode(WeatherApiModel.self, from: data)
                self.id = model.id
                self.name = model.name
                self.dt = model.dt
                self.base = model.base
                self.visibility = model.visibility
                self.coord = model.coord
                self.weather = model.weather
                self.main = model.main
                self.wind = model.wind
                self.sys = model.sys
                self.coreDataModel = model.coreDataModel
            } catch {
                throw NSError.parseError
            }
        } else {
            throw NSError.parseError
        }
    }
    
    convenience required init(json: [String : Any]) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            try self.init(data: jsonData)
        } catch {
            throw NSError.parseError
        }
    }
    
    init(weatherModelParameters: WeatherModelParameters, cordsParameters: CordsParameters, weatherParameters: [WeatherParameters], mainParameters: MainParameters, windParameters: WindParameters, sysParameters: SysParameters) {
        id = weatherModelParameters.id
        name = weatherModelParameters.name
        dt = weatherModelParameters.dt
        base = weatherModelParameters.base
        visibility = weatherModelParameters.visibility
        coord = Cords(parameters: cordsParameters)
        weather = weatherParameters.map({  Weather(parameters: $0) })
        main = Main(parameters: mainParameters)
        wind = Wind(parameters: windParameters)
        sys = Sys(parameters: sysParameters)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case dt
        case base
        case visibility
        case coord
        case weather
        case main
        case wind
        case sys
    }
}

class Cords: Codable {
    let longitude: Double
    let latitude: Double
    
    init(parameters: CordsParameters) {
        longitude = parameters.longitude
        latitude = parameters.latitude
    }
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

class Weather: Codable {
    let id: Int
    let main: String
    let descriptionText: String
    let icon: String
    
    init(parameters: WeatherParameters) {
        id = parameters.id
        main = parameters.main
        descriptionText = parameters.descriptionText
        icon = parameters.icon
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case main
        case descriptionText = "description"
        case icon
    }
}

class Main: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Double
    let tempMin: Double
    let tempMax: Double
    
    init(parameters: MainParameters) {
        temp = parameters.temp
        pressure = parameters.pressure
        humidity = parameters.humidity
        tempMin = parameters.tempMin
        tempMax = parameters.tempMax
    }
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

class Wind: Codable {
    let speed: Float
    let deg: Float
    
    init(parameters: WindParameters) {
        speed = parameters.speed
        deg = parameters.deg
    }
}

class Sys: Codable {
    let id: Int?
    let type: Int?
    let message: Float
    let country: String
    var countryName: String? {
        let locale = Locale.current as NSLocale
        return locale.displayName(forKey: .countryCode, value: country)
    }
    let sunrise: TimeInterval
    var sunriseDateString: String {
        let date = Date(timeIntervalSince1970: sunrise)
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .medium
        let stringDate = dateFormater.string(from: date)
        return stringDate
    }
    let sunset: TimeInterval
    var sunsetDateString: String {
        let date = Date(timeIntervalSince1970: sunset)
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .medium
        let stringDate = dateFormater.string(from: date)
        return stringDate
    }
    
    init(parameters: SysParameters) {
        id = parameters.id
        type = parameters.type
        message = parameters.message
        country = parameters.country
        sunrise = parameters.sunrise
        sunset = parameters.sunset
    }
}
