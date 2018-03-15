//
//  CoreDataWeatherDataSerivce.swift
//  Weather Logger
//
//  Created by Mike Haydan on 15/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

typealias WeatherArrayDataCompletion = ((Result<[WeatherApiModel]>) -> ())

protocol CoreDataWeatherDataSerivce {
    func add(model: WeatherApiModel)
    func delete(model: WeatherApiModel) -> Bool
    func fetchWeather(completion: @escaping WeatherArrayDataCompletion)
}

class CoreDataWeatherDataSerivceImplementation: CoreDataWeatherDataSerivce {
    
    let viewContext: NSManagedObjectContextProtocol
    
    init(viewContext: NSManagedObjectContextProtocol) {
        self.viewContext = viewContext
    }
    
    func add(model: WeatherApiModel) {
        
    }
    
    func delete(model: WeatherApiModel) -> Bool {
        return true
    }
    
    func fetchWeather(completion: @escaping WeatherArrayDataCompletion) {
        let weatherArray = viewContext.allEntities(withType: WeatherLocalModel.self)
        var seralizerModelsArray: [WeatherApiModel] = []
        for item in weatherArray {
            if let model = try? item.weatherModel() {
                seralizerModelsArray.append(model)
            } else {
                completion(.failure(CoreDataError(message: "Failed adding the book in the data base")))
                break
            }
        }
        completion(.success(seralizerModelsArray))
    }
}
