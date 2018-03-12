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
    let description: String
    let icon: String
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
    let sunrise: Int
    let sunset: Int
}
