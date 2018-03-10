//
//  WeatherDataRequestProtocol.swift
//  Weather Logger
//
//  Created by Mike Haydan on 10/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

typealias WeatherDataCompletion = ((Result<[WeatherApiModel]>) -> ())

protocol WeatherDataRequest {
    func fetchWeatherFor(latitude: Float, andLongitude longitude: Float, completion: @escaping WeatherDataCompletion)
}
