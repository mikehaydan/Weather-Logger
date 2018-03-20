//
//  CoreDataWeatherDataSerivce.swift
//  Weather Logger
//
//  Created by Mike Haydan on 15/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

typealias WeatherArrayDataCompletion = ((Result<[WeatherModel]>) -> ())
typealias WeatherVoidDataCompletion = ((Result<Void>) -> ())
typealias WeatherCoreDataCompletion = ((Result<WeatherLocalModel>) -> ())

protocol CoreDataWeatherDataSerivce {
    func add(model: WeatherModel, complation: WeatherCoreDataCompletion)
    func delete(model: WeatherModel) -> Bool
    func fetchWeather(completion: @escaping WeatherArrayDataCompletion)
}

class CoreDataWeatherDataSerivceImplementation: CoreDataWeatherDataSerivce {

    let viewContext: NSManagedObjectContextProtocol
    
    init(viewContext: NSManagedObjectContextProtocol) {
        self.viewContext = viewContext
    }
    
    func add(model: WeatherModel, complation: WeatherCoreDataCompletion) {
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
    
    func delete(model: WeatherModel) -> Bool {
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
            return false
        }
    }
    
    func fetchWeather(completion: @escaping WeatherArrayDataCompletion) {
        let weatherArray = viewContext.allEntities(withType: WeatherLocalModel.self)
        var seralizerModelsArray: [WeatherModel] = []
        for item in weatherArray {
            do {
                let model = try item.weatherModel()
                seralizerModelsArray.append(model)
                model.coreDataModel = item
            } catch {
                let returnedError = error as! CoreDataError
                completion(.failure(CoreDataError(message: returnedError.localizedDescription)))
                return
            }
        }
        completion(.success(seralizerModelsArray))
    }
}
