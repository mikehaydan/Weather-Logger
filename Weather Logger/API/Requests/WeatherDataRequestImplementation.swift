//
//  WeatherDataRequestImplementation.swift
//  Weather Logger
//
//  Created by Mike Haydan on 11/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

class GetWeatherByCoordsRequest: ApiRequest {
    private var latitude: Float = 0
    private var longitude: Float = 0
    
    var urlRequest: URLRequest {
        let urlString = URLs.getWeatherBy(latitude: latitude, longitude: longitude)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HttpMehod.get.rawValue
        
        return request
    }
    
    func configure(latitude: Float, longitude: Float) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}


class WeatherDataRequestImplementation: WeatherDataRequest {
    
    func fetchWeatherFor(latitude: Float, andLongitude longitude: Float, completion: @escaping WeatherDataCompletion) {
        
    }
}
