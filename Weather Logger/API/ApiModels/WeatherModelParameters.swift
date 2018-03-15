//
//  WeatherParameters.swift
//  Weather Logger
//
//  Created by Mike Haydan on 15/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

struct WeatherModelParameters {
    var id: Int
    var name: String
    var dt: Int
    var base: String
    var visibility: Double?
}

struct CordsParameters {
    var longitude: Double
    var latitude: Double
}

struct WeatherParameters {
    var id: Int
    var main: String
    var descriptionText: String
    var icon: String
}

struct MainParameters {
    var temp: Double
    var pressure: Double
    var humidity: Double
    var tempMin: Double
    var tempMax: Double
}

struct WindParameters {
    var speed: Float
    var deg: Float
}

struct SysParameters {
    var id: Int?
    var type: Int?
    var message: Float
    var country: String
    var sunrise: TimeInterval
    var sunset: TimeInterval
}
