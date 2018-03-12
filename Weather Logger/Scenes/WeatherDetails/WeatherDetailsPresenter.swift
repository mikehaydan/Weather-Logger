//
//  WeatherDetailsPresenter.swift
//  Weather Logger
//
//  Created by Mike Haydan on 12/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

protocol WeatherDetailsViewDelegate: class {
    var preseterView: WeatherDetailsView { get }
}

protocol WeatherDetailsPresenter {
    var dataSourceCount: Int { get }
    init(view: WeatherDetailsView, model: WeatherApiModel?)
    func set(model: WeatherApiModel?)
    func getCellIdentifierAt(index: Int) -> String
}

protocol WeatherDetailsView: class {
    var presenter: WeatherDetailsPresenter! { set get }
    func reloadDetails()
}

class WeatherDetailsPresenterImplementation: WeatherDetailsPresenter {
    
    //MARK: - Properties
    
    private unowned let view: WeatherDetailsView
    
    private var model: WeatherApiModel?
    
    private var dataSource: [WeatherDetailsCellModel] = []
    
    var dataSourceCount: Int {
        return dataSource.count
    }
    
    //MARK: - LifeCycle
    
    required init(view: WeatherDetailsView, model: WeatherApiModel?) {
        self.view = view
        self.model = model
    }
    
    //MARK: - IBActions
    
    
    
    //MARK: - Private
    
    
    
    //MARK: - Public
    
    func getCellIdentifierAt(index: Int) -> String {
        return dataSource[index].cellIdentifier
    }
    
    func set(model: WeatherApiModel?) {
        self.model = model
        view.reloadDetails()
    }
}

//MARK: - WeatherDetailsViewDelegate

extension WeatherDetailsPresenterImplementation: WeatherDetailsViewDelegate {
    
    var preseterView: WeatherDetailsView {
        return view
    }
}
