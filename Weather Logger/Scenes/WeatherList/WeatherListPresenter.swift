//
//  WeatherListPresenter.swift
//  Weather Logger
//
//  Created by Mike Haydan on 11/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

private struct WeatherListPresenterConstants {
    static let weatherListTableViewCellIdentifier = "WeatherListTableViewCell"
}

protocol WeatherListView: class {
    func show(message: String)
    func showWithRetry(message: String, retryText: String, retryHandler: @escaping () -> ())
    func reloadView()
    func showProgres()
    func hideProgres()
}

protocol WeatherListPresenter {
    var dataSourceCount: Int { get }
    var weatherCellIndetifier: String { get }
    init(view: WeatherListView)
    func prepareLocation()
    func configure(view: WeatherListCellView, atIndex index: Int)
}

//MARK: - WeatherListPresenterImplementation

class WeatherListPresenterImplementation: WeatherListPresenter {
    
    //MARK: - Properties
    
    private var dataSource: [WeatherApiModel] = []
    
    private unowned let view: WeatherListView
    
    private lazy var locationSerive: LocationService = {
        return LocationServiceImplementation(delegate: self)
    }()
    
    private lazy var weatherRequest: WeatherDataRequest = {
        let apiClient = ApiClientImplelentation.defaultConfiguration
        return WeatherDataRequestImplementation(apiClient: apiClient)
    }()
    
    var dataSourceCount: Int {
        return dataSource.count
    }
    
    var weatherCellIndetifier: String {
        return WeatherListPresenterConstants.weatherListTableViewCellIdentifier
    }
    
    //MARK: - LifeCycle
    
    required init(view: WeatherListView) {
        self.view = view
    }
    
    //MARK: - Private
    
    private func getWeatherFor(longitude: Double, latitude: Double) {
        view.showProgres()
        weatherRequest.fetchWeatherFor(latitude: latitude, andLongitude: longitude) { [weak self] (result) in
            if let strongSelf = self {
                strongSelf.view.hideProgres()
                switch result {
                case let .success(model):
                    strongSelf.dataSource = [model]
                    strongSelf.view.reloadView()
                case let .failure(error):
                    strongSelf.view.showWithRetry(message: error.localizedDescription, retryText: "Retry", retryHandler: { [ weak self] in
                        self?.getWeatherFor(longitude: longitude, latitude: latitude)
                    })
                }
            }
        }
    }
    
    //MARK: - Public
    
    func prepareLocation() {
        if !locationSerive.prepareLocationService() {
            view.show(message: "Please, give access for location")
        }
    }
    
    func configure(view: WeatherListCellView, atIndex index: Int) {
        
    }
}

//MARK: - LocationServiceDelegate

extension WeatherListPresenterImplementation: LocationServiceDelegate {
    func updateLocationWith(longitude: Double, latitude: Double) {
        getWeatherFor(longitude: longitude, latitude: latitude)
    }
}
