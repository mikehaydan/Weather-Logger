//
//  WeatherAdditionalDataTableViewCell.swift
//  Weather Logger
//
//  Created by Mike Haydan on 12/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

class WeatherAdditionalDataTableViewCell: BaseWeatherDetailsTableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet private weak var countryLabel: UILabel!
    
    @IBOutlet private weak var sunriseDataLabel: UILabel!
    
    @IBOutlet private weak var sunsetDataLabel: UILabel!
    
    //MARK: - LifeCycle
    
    
    //MARK: - Private
    
    
    //MARK: - Public
    
    override func set(model: WeatherDetailsCellModel) {
        super.set(model: model)
        
        let model = model.model as! Sys
        countryLabel.text = model.countryName
        sunriseDataLabel.text = model.sunriseDateString
        sunsetDataLabel.text = model.sunsetDateString
    }
    
}
