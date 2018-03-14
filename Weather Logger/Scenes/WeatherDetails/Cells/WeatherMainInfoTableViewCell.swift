//
//  WeatherMainInfoTableViewCell.swift
//  Weather Logger
//
//  Created by Mike Haydan on 12/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

class WeatherMainInfoTableViewCell: BaseWeatherDetailsTableViewCell {

    //MARK: - Properties
    
    @IBOutlet private weak var temperatureDataLabel: UILabel!
    
    @IBOutlet private weak var humidityDataLabel: UILabel!
    
    @IBOutlet private weak var presureDataLabel: UILabel!
    
    //MARK: - LifeCycle

    
    //MARK: - Private
    
    
    //MARK: - Public
    
   override func set(model: WeatherDetailsCellModel) {
        super.set(model: model)
    
        let model = model.model as! Main
        temperatureDataLabel.text = "\(model.temp)°C"
        humidityDataLabel.text = "\(model.humidity)"
        presureDataLabel.text = "\(model.pressure)"
    }

}
