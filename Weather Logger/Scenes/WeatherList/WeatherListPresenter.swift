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
    func showDetailsViewWith(model: WeatherModel, forView view: WeatherDetailsView)
    func reloadViewAnimated()
}

protocol WeatherListPresenter {
    var dataSourceCount: Int { get }
    var cellHeight: Float { get }
    var weatherCellIndetifier: String { get }
    init(view: WeatherListView)
    func prepareDataSource()
    func prepareLocation()
    func configure(view: WeatherListCellView, atIndex index: Int)
    func configure(view: WeatherDetailsView, withModel model: WeatherModel)
}

//MARK: - WeatherListPresenterImplementation

class WeatherListPresenterImplementation: WeatherListPresenter {
    
    //MARK: - Properties
    
    weak var delegate: WeatherDetailsViewDelegate!
    
    var dataSource: [WeatherModel] = []
    
    private unowned let view: WeatherListView
    
    var locationSerive: LocationService!
    
    var weatherRequest: WeatherDataRequest!
    
    var coreDataSerivce: CoreDataWeatherDataSerivce!
    
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
        
        self.prepareServices()
    }
    
    //MARK: - Private
    
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
    
    private func prepareServices() {
        coreDataSerivce = CoreDataWeatherDataSerivceImplementation(viewContext: CoreDataStackImpementation.shared.persistentContainer.viewContext)
        
        let apiClient = ApiClientImplelentation.defaultConfiguration
        weatherRequest = WeatherDataRequestImplementation(apiClient: apiClient)
        
        locationSerive = LocationServiceImplementation(delegate: self)
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
                if case let .success(models) = result  {
                    strongSelf.dataSource = models
                }
                strongSelf.prepareLocation()
            }
        }
    }
    
    func configure(view: WeatherListCellView, atIndex index: Int) {
        let model = dataSource[index]
        view.presenter.configureWith(model: model, delegate: self, atIndex: index)
    }
    
    func configure(view: WeatherDetailsView, withModel model: WeatherModel) {
        view.presenter.set(model: model)
        view.presenter.savedAction = { [weak self] (savedModel) in
            self?.view.reloadView()
        }
    }
}

//MARK: - LocationServiceDelegate

extension WeatherListPresenterImplementation: LocationServiceDelegate {
    
    func updateLocationWith(longitude: Double, latitude: Double) {
        getWeatherFor(longitude: longitude, latitude: latitude)
    }
}

extension WeatherListPresenterImplementation: WeatherListCellDelegate {
    
    func deleteButtonTappedAt(index: Int) {
        let model = dataSource[index]
        if coreDataSerivce.delete(model: model) {
            dataSource.remove(at: index)
            view.reloadViewAnimated()
            if delegate.presentedModel === model {
                delegate.deletePresentedModel()
            }
        } else {
            view.show(message: "An error occurred, while delete object")
        }
    }
    
    func detailsButtonTappedAt(index: Int) {
        let model = dataSource[index]
        
        configure(view: delegate!.preseterView, withModel: model)
        view.showDetailsViewWith(model: model, forView: delegate!.preseterView)
    }
}
