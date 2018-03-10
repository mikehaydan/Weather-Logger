//
//  URLs.swift
//  Weather Logger
//
//  Created by Mike Haydan on 11/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

struct URLs {
    private static let APiKey = "6b57a207d80704b8c22324e35eb87258"
    
    static let baseUrl = "api.openweathermap.org/data/2.5/weather?APPID=\(APiKey)"
    
    static func getWeatherBy(latitude: Float, longitude: Float) -> String {
        return "\(URLs.baseUrl)&lat=\(latitude)&lon=\(longitude)"
    }
}