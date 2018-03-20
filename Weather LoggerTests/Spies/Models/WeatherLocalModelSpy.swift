//
//  WeatherLocalModelSpy.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 20/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
import CoreData
@testable import Weather_Logger


class WeatherLocalModelSpy: WeatherLocalModel {
    
    var returnedError: Error?
    
    override func set(model: WeatherModel) throws {
        if let returnedError = returnedError {
            throw returnedError
        } else {
            try super.set(model: model)
        }
    }
}
