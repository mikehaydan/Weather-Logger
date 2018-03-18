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
    static let weatherListTableViewCellHeight: Float = 75.0
}

protocol WeatherListView: class {
    func show(message: String)
    func showWithRetry(message: String, retryText: String, retryHandler: @escaping () -> ())
    func reloadView()
    func showProgres()
    func hideProgres()
    func showDetailsViewWith(model: WeatherApiModel, forView view: WeatherDetailsView)
}

protocol WeatherListPresenter {
    var dataSourceCount: Int { get }
    var cellHeight: Float { get }
    var weatherCellIndetifier: String { get }
    init(view: WeatherListView)
    func prepareDataSource()
    func prepareLocation()
    func configure(view: WeatherListCellView, atIndex index: Int)
    func configure(view: WeatherDetailsView, withModel model: WeatherApiModel)
}

//MARK: - WeatherListPresenterImplementation

class WeatherListPresenterImplementation: WeatherListPresenter {
    
    //MARK: - Properties
    
    weak var delegate: WeatherDetailsViewDelegate!
    
    private var dataSource: [WeatherApiModel] = []
    
    private unowned let view: WeatherListView
    
    private lazy var locationSerive: LocationService = {
        return LocationServiceImplementation(delegate: self)
    }()
    
    private lazy var weatherRequest: WeatherDataRequest = {
        let apiClient = ApiClientImplelentation.defaultConfiguration
        return WeatherDataRequestImplementation(apiClient: apiClient)
    }()
    
    private lazy var coreDataSerivce: CoreDataWeatherDataSerivce = {
        let serivce = CoreDataWeatherDataSerivceImplementation(viewContext: CoreDataStackImpementation.shared.persistentContainer.viewContext)
        return serivce
    }()
    
    var dataSourceCount: Int {
        return dataSource.count
    }
    
    var cellHeight: Float {
        return WeatherListPresenterConstants.weatherListTableViewCellHeight
        
    }
    
    var weatherCellIndetifier: String {
        return WeatherListPresenterConstants.weatherListTableViewCellIdentifier
    }
    
    //MARK: - LifeCycle
    
    required init(view: WeatherListView) {
        self.view = view
    }
    
    //MARK: - Private
    
    private func save(model: WeatherApiModel) {
        coreDataSerivce.add(model: model) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(): break
                strongSelf.view.show(message: "Success")
            case let .failure(error):
                strongSelf.view.show(message: error.localizedDescription)
            }
        }
    }
    
    private func getWeatherFor(longitude: Double, latitude: Double) {
        view.showProgres()
        weatherRequest.fetchWeatherFor(latitude: latitude, andLongitude: longitude) { [weak self] (result) in
            if let strongSelf = self {
                strongSelf.view.hideProgres()
                switch result {
                case let .success(model):
                    strongSelf.dataSource.append(model)
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
    
    func prepareDataSource() {
        coreDataSerivce.fetchWeather { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                case let .success(models):
                    strongSelf.dataSource = models
                case let .failure(error):
                    print(error.localizedDescription)
                }
                strongSelf.prepareLocation()
            }
        }
    }
    
    func configure(view: WeatherListCellView, atIndex index: Int) {
        let model = dataSource[index]
        view.presenter.configureWith(model: model, delegate: self, atIndex: index)
    }
    
    func configure(view: WeatherDetailsView, forModelAt index: Int) {
        let model = dataSource[index]
        let presenter = WeatherDetailsPresenterImplementation(view: view, model: model)
        view.presenter = presenter
    }
    
    func configure(view: WeatherDetailsView, withModel model: WeatherApiModel) {
        view.presenter.set(model: model)
    }
}

//MARK: - LocationServiceDelegate

extension WeatherListPresenterImplementation: LocationServiceDelegate {
    
    func updateLocationWith(longitude: Double, latitude: Double) {
        getWeatherFor(longitude: longitude, latitude: latitude)
    }
}

extension WeatherListPresenterImplementation: WeatherListCellDelegate {
    
    func detailsButtonTappedAt(index: Int) {
        let model = dataSource[index]
        view.showDetailsViewWith(model: model, forView: delegate!.preseterView)
    }
    
    func saveButtonTappedAt(index: Int) {
        let model = dataSource[index]
        save(model: model)
    }
}
