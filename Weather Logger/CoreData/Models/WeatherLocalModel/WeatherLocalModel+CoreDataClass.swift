//
//  WeatherLocalModel+CoreDataClass.swift
//  Weather Logger
//
//  Created by Mike Haydan on 13/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//
//

import Foundation
import CoreData

public class WeatherLocalModel: NSManagedObject, InitializableWithData, InitializableWithJson {
    
    convenience required public init(json: [String : Any]) throws {
        throw NSError.parseError
    }
    
    required public convenience init(data: Data?) throws {
        if let data = data {
            do {
                if let json = try? JSONSerialization.jsonObject(with: data), let jsonDictionary = json as? [String: Any] {
                    try self.init(json: jsonDictionary)
                } else {
                    throw NSError.parseError
                }
            } catch {
                throw NSError.parseError
            }
        } else {
            throw NSError.parseError
        }
    }
}
