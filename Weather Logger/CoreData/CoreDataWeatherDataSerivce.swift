//
//  CoreDataWeatherDataSerivce.swift
//  Weather Logger
//
//  Created by Mike Haydan on 15/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

typealias WeatherArrayDataCompletion = ((Result<[WeatherApiModel]>) -> ())
typealias WeatherVoidDataCompletion = ((Result<Void>) -> ())
typealias WeatherCoreDataCompletion = ((Result<WeatherLocalModel>) -> ())

protocol CoreDataWeatherDataSerivce {
    func add(model: WeatherApiModel, complation: WeatherCoreDataCompletion)
    func delete(model: WeatherApiModel) -> Bool
    func fetchWeather(completion: @escaping WeatherArrayDataCompletion)
}

class CoreDataWeatherDataSerivceImplementation: CoreDataWeatherDataSerivce {

    let viewContext: NSManagedObjectContextProtocol
    
    init(viewContext: NSManagedObjectContextProtocol) {
        self.viewContext = viewContext
    }
    
    func add(model: WeatherApiModel, complation: WeatherCoreDataCompletion) {
        if let coreDataModel = viewContext.addEntity(withType: WeatherLocalModel.self) {
            do {
                try coreDataModel.set(model: model)
                do {
                    try viewContext.save()
                    complation(.success(coreDataModel))
                } catch {
                    complation(.failure(error))
                }
            } catch {
                complation(.failure(error))
            }
        } else {
            complation(.failure(CoreDataError(message: "Failed adding the weather in the data base")))
        }
    }
    
    func delete(model: WeatherApiModel) -> Bool {
        let predicate = NSPredicate(format: "id==%d", model.id)
        let entities = viewContext.allEntities(withType: WeatherLocalModel.self, predicate: predicate)
        if let entity = entities.first {
            viewContext.delete(entity)
            do {
                try viewContext.save()
                return true
            } catch {
                return false
            }
        } else {
            return true
        }
    }
    
    func fetchWeather(completion: @escaping WeatherArrayDataCompletion) {
        let weatherArray = viewContext.allEntities(withType: WeatherLocalModel.self)
        var seralizerModelsArray: [WeatherApiModel] = []
        for item in weatherArray {
            if var model = try? item.weatherModel() {
                seralizerModelsArray.append(model)
                model.coreDataModel = item
            } else {
                completion(.failure(CoreDataError(message: "Failed getting the weather from the data base")))
                break
            }
        }
        completion(.success(seralizerModelsArray))
    }
}
