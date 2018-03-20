//
//  WeatherDataRequestImplementation.swift
//  Weather Logger
//
//  Created by Mike Haydan on 11/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

//MARK: - GetWeatherByCoordsRequest

class GetWeatherByCoordsRequest: ApiRequest {
    
    //MARK: - Properties
    
    private var latitude: Double = 0
    private var longitude: Double = 0
    
    var urlRequest: URLRequest {
        let urlString = URLs.getWeatherBy(latitude: latitude, longitude: longitude)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HttpMehod.get.rawValue
        
        return request
    }
    
    //MARK: - Public
    
    func configure(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

//MARK: - WeatherDataRequestImplementation

class WeatherDataRequestImplementation: WeatherDataRequest {
    
    //MARK: - Properties

    let apiClient: ApiClient
    
    //MARK: - LifeCycle
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    //MARK: - Public
    
    func fetchWeatherFor(latitude: Double, andLongitude longitude: Double, completion: @escaping WeatherDataCompletion) {
        let request = GetWeatherByCoordsRequest()
        request.configure(latitude: latitude, longitude: longitude)
        apiClient.execute(request: request) { (result: Result<ApiResponse<WeatherModel>>) in
            switch result {
            case let .success(response):
                let model = response.model
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
        
    }
}
