//
//  WeatherApiModel.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 18/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
import CoreData
@testable import Weather_Logger

extension WeatherModel {
    
    static func createModelsArray(count: Int = 2) -> [WeatherModel] {
        var arrayModels: [WeatherModel] = []
        for i in 0..<count {
            let stringJson = """
            {"coord":{"lon":139.01,"lat":35.02},"weather":[{"id":\(i),"main":"Clear","description":"clear sky","icon":"01n"}],"base":"stations","main":{"temp":285.514,"pressure":1013.75,"humidity":100,"temp_min":285.514,"temp_max":285.514,"sea_level":1023.22,"grnd_level":1013.75},"wind":{"speed":5.52,"deg":311},"clouds":{"all":0},"dt":1485792967,"sys":{"message":0.0025,"country":"JP","sunrise":1485726240,"sunset":1485763863},"id":1907296,"name":"Tawarano","cod":200}
            """
            let data = stringJson.data(using: .utf8)
            let model = try! WeatherModel(data: data)
            arrayModels.append(model)
        }
        return arrayModels
    }
    
    static func createLocalModelsArray(count: Int = 2) -> [WeatherLocalModel] {
        let models = createModelsArray(count: count)
        var localModels: [WeatherLocalModel] = []
        for item in models {
            let entity = NSEntityDescription.entity(forEntityName: String(describing: WeatherLocalModel.self), in: InMemoryCoreDataStack.shared.persistentContainer.viewContext)
            let model = WeatherLocalModel(entity: entity!, insertInto: InMemoryCoreDataStack.shared.persistentContainer.viewContext)
            try! model.set(model: item)
            localModels.append(model)
        }
        return localModels
    }
    
    static func createSpyLocalModelsArray(count: Int = 2) -> [WeatherLocalModelSpy] {
        let models = createModelsArray(count: count)
        var localModels: [WeatherLocalModelSpy] = []
        for item in models {
            let entity = NSEntityDescription.entity(forEntityName: String(describing: WeatherLocalModel.self), in: InMemoryCoreDataStack.shared.persistentContainer.viewContext)
            let model = WeatherLocalModelSpy(entity: entity!, insertInto: InMemoryCoreDataStack.shared.persistentContainer.viewContext)
            try! model.set(model: item)
            localModels.append(model)
        }
        return localModels
    }
}


