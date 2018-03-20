//
//  WeatherDataRequestSpy.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 18/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
@testable import Weather_Logger

class WeatherDataRequestStub: WeatherDataRequest {
    
    var resultToBeReturned: Result<WeatherModel>!
    
    func fetchWeatherFor(latitude: Double, andLongitude longitude: Double, completion: @escaping WeatherDataCompletion) {
        completion(resultToBeReturned)
    }
    
    
}
