//
//  WeatherInfoTableViewCellSpy.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 18/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
@testable import Weather_Logger

class WeatherInfoTableViewCellSpy: WeatherDetailsCellView {
    
    //MARK: - Properties
    
    var weatherIcon = ""
    var weatherDescription = ""
    
    //MARK: - Public
    
    func set(model: WeatherDetailsCellModel) {
        let model = model.model as! Weather
        weatherIcon = model.icon
        weatherDescription = model.descriptionText
    }
}

class WeatherMainInfoTableViewCellSpy: WeatherDetailsCellView {
    
    //MARK: - Properties
    
    var temperatureText = ""
    var humidityDataText = ""
    var presureDataText = ""
    
    //MARK: - Public
    
    func set(model: WeatherDetailsCellModel) {
        let model = model.model as! Main
        temperatureText = "\(model.temp)°C"
        humidityDataText = "\(model.humidity)"
        presureDataText = "\(model.pressure)"
    }
}

class WeatherAdditionalDataTableViewCellSpy: WeatherDetailsCellView {
    
    //MARK: - Properties
    
    var countryText: String? = ""
    var sunriseDataText = ""
    var sunsetDataText = ""
    
    //MARK: - Public
    
    func set(model: WeatherDetailsCellModel) {
        let model = model.model as! Sys
        countryText = model.countryName
        sunriseDataText = model.sunriseDateString
        sunsetDataText = model.sunsetDateString
    }
}
