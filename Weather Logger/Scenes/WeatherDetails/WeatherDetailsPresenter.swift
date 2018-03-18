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
    var presentedModel: WeatherApiModel? { get }
    func deletePresentedModel()
}

protocol WeatherDetailsPresenter {
    var dataSourceCount: Int { get }
    var savedAction: ((WeatherApiModel) -> ())? { set get }
    init(view: WeatherDetailsView, model: WeatherApiModel?)
    func set(model: WeatherApiModel?)
    func getCellIdentifierAt(index: Int) -> String
    func prepapreDataSource()
    func configure(view: WeatherDetailsCellView, atIndex index: Int)
    func saveData()
}

protocol WeatherDetailsView: class {
    var presenter: WeatherDetailsPresenter! { set get }
    func reloadDetails()
    func set(title: String?)
    func show(message: String)
    func save(enabled: Bool)
}

class WeatherDetailsPresenterImplementation: WeatherDetailsPresenter {
    
    //MARK: - Properties
    
    private unowned let view: WeatherDetailsView
    
    private weak var model: WeatherApiModel? {
        didSet {
            prepapreDataSource()
        }
    }
    
    private var dataSource: [WeatherDetailsCellModel] = []
    
    private lazy var coreDataSerivce: CoreDataWeatherDataSerivce = {
        let serivce = CoreDataWeatherDataSerivceImplementation(viewContext: CoreDataStackImpementation.shared.persistentContainer.viewContext)
        return serivce
    }()
    
    var dataSourceCount: Int {
        return dataSource.count
    }
    
    var savedAction: ((WeatherApiModel) -> ())?
    
    //MARK: - LifeCycle
    
    required init(view: WeatherDetailsView, model: WeatherApiModel?) {
        self.view = view
        self.model = model
    }
    
    //MARK: - IBActions
    
    
    
    //MARK: - Private
    
    
    
    //MARK: - Public
    
    func saveData() {
        if let model = model {
            coreDataSerivce.add(model: model) { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case let .success(coreDataModel):
                    strongSelf.model?.coreDataModel = coreDataModel
                strongSelf.view.show(message: "Success")
                strongSelf.view.save(enabled: false)
                strongSelf.savedAction?(model)
                case let .failure(error):
                    strongSelf.view.show(message: error.localizedDescription)
                }
            }
        }
    }
    
    func prepapreDataSource() {
        let title: String?
        if let model = model {
            let weatherModels = model.weather
            let main = model.main
            let sys = model.sys
            let weatherDetailsArray = weatherModels.map({ return WeatherWeatherDetailsCellModelImplementation(model: $0, cellIdentifier: WeatherInfoTableViewCell.nibName) })
            dataSource = weatherDetailsArray
            dataSource += [WeatherWeatherDetailsCellModelImplementation(model: sys, cellIdentifier: WeatherAdditionalDataTableViewCell.nibName),
                           WeatherWeatherDetailsCellModelImplementation(model: main, cellIdentifier: WeatherMainInfoTableViewCell.nibName)]
            title = model.name
            let isSaveEnabled = model.coreDataModel == nil
            view.save(enabled: isSaveEnabled)
        } else {
            dataSource = []
            title = nil
            view.save(enabled: false)
        }
        view.reloadDetails()
        view.set(title: title)
    }
    
    func getCellIdentifierAt(index: Int) -> String {
        return dataSource[index].cellIdentifier
    }
    
    func set(model: WeatherApiModel?) {
        self.model = model
    }
    
    func configure(view: WeatherDetailsCellView, atIndex index: Int) {
        let model = dataSource[index]
        view.set(model: model)
    }
}

//MARK: - WeatherDetailsViewDelegate

extension WeatherDetailsPresenterImplementation: WeatherDetailsViewDelegate {
    
    var preseterView: WeatherDetailsView {
        return view
    }
    
    var presentedModel: WeatherApiModel? {
        return model
    }
    
    func deletePresentedModel() {
        model = nil
    }
}
