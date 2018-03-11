//
//  WeatherListCellPresenter.swift
//  Weather Logger
//
//  Created by Mike Haydan on 11/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

protocol WeatherListCellDelegate: class {
    func detailsButtonTappedAt(index: Int)
}

protocol WeatherListCellPresenter {
    init(view: WeatherListCellView)
    func detailsButtonTapped()
    func configureWith(model: WeatherApiModel, delegate: WeatherListCellDelegate?, atIndex index: Int)
}

protocol WeatherListCellView: class {
    var presenter: WeatherListCellPresenter! { get }
    func set(temperature: String, andDate date: String)
    func set(detailsButtonText: String)
}

class WeatherListCellPresenterImplementation: WeatherListCellPresenter {
    
    //MARK: - Properties
    
    unowned let view: WeatherListCellView
    
    weak var delegate: WeatherListCellDelegate?
    
    var index: Int!
    
    //MARK: - LifeCycle
    
    required init(view: WeatherListCellView) {
        self.view = view
    }
    
    //MARK: - IBActions
    
    
    
    //MARK: - Private
    
    
    
    //MARK: - Public
    
    func configureWith(model: WeatherApiModel, delegate: WeatherListCellDelegate?, atIndex index: Int) {
        self.index = index
        self.delegate = delegate
    }
    
    func detailsButtonTapped() {
        delegate?.detailsButtonTappedAt(index: index)
    }
}
