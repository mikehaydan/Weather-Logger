//
//  CoreDataWeatherDataSerivceSpy.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 18/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
@testable import Weather_Logger

class CoreDataWeatherDataServiceStub: CoreDataWeatherDataSerivce {
    
    var addingResultToBeReturned: Result<WeatherLocalModel>!
    var deleteResultToBeReturned: Bool!
    var fetchResultToBeReturned: Result<[WeatherApiModel]>!
    
    func add(model: WeatherApiModel, complation: (Result<WeatherLocalModel>) -> ()) {
        complation(addingResultToBeReturned)
    }
    
    func delete(model: WeatherApiModel) -> Bool {
        return deleteResultToBeReturned
    }
    
    func fetchWeather(completion: @escaping WeatherArrayDataCompletion) {
        completion(fetchResultToBeReturned)
    }
}
