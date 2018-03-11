//
//  WeatherListTableViewCell.swift
//  Weather Logger
//
//  Created by Mike Haydan on 11/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

class WeatherListTableViewCell: UITableViewCell, WeatherListCellView {
    
    //MARK: - Properties
    
    var presenter: WeatherListCellPresenter!
    
    //MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        presenter = WeatherListCellPresenterImplementation(view: self)
    }
    
    //MARK: - IBActions
    
    
    
    //MARK: - Private
    
    
    
    //MARK: - Public
    
    func set(temperature: String, andDate date: String) {
        
    }

    func set(detailsButtonText: String) {
        
    }
}
