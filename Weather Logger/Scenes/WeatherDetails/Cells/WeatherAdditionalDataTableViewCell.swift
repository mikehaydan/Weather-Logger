//
//  WeatherAdditionalDataTableViewCell.swift
//  Weather Logger
//
//  Created by Mike Haydan on 12/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

class WeatherAdditionalDataTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet private weak var countryLabel: UILabel!
    
    @IBOutlet private weak var sunriseDataLabel: UILabel!
    
    @IBOutlet private weak var sunsetDataLabel: UILabel!
    
    //MARK: - LifeCycle
    
    
    //MARK: - Private
    
    
    //MARK: - Public
    
}

//MARK: - WeatherDetailsTableViewCell

extension WeatherAdditionalDataTableViewCell: WeatherDetailsCellView {
    
    func set(model: WeatherDetailsCellModel) {
        let model = model as! Sys
        countryLabel.text = model.country
        sunriseDataLabel.text = "\(model.sunrise)"
        sunsetDataLabel.text = "\(model.sunset)"
    }
}
