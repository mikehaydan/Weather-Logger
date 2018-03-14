//
//  WeatherApiModel.swift
//  Weather Logger
//
//  Created by Mike Haydan on 10/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

struct WeatherApiModel: InitializableWithData, InitializableWithJson, Codable {
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
    
    init(data: Data?) throws {
        if let data = data {
            let jsonDecoder = JSONDecoder()
            do {
                let model = try jsonDecoder.decode(WeatherApiModel.self, from: data)
                self = model
            } catch {
                throw NSError.parseError
            }
        } else {
            throw NSError.parseError
        }
    }
    
    init(json: [String : Any]) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            try self.init(data: jsonData)
        } catch {
            throw NSError.parseError
        }
    }
}

struct Cords: Codable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let descriptionText: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case descriptionText = "description"
        case icon
    }
}

struct Main: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Wind: Codable {
    let speed: Float
    let deg: Float
}

struct Sys: Codable {
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
}
