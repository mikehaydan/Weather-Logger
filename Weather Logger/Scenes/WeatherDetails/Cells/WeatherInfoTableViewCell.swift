//
//  WeatherDataTableViewCell.swift
//  Weather Logger
//
//  Created by Mike Haydan on 12/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

class WeatherInfoTableViewCell: BaseWeatherDetailsTableViewCell {

    //MARK: - Properties
    
    @IBOutlet private weak var weatherIconImageView: UIImageView!
    
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    
    //MARK: - Public

    override func set(model: WeatherDetailsCellModel) {
        super.set(model: model)
        
        let model = model.model as! Weather
        weatherIconImageView.image = UIImage(named: model.icon)
        weatherDescriptionLabel.text = model.descriptionText
    }
}

