//
//  WeatherMainInfoTableViewCell.swift
//  Weather Logger
//
//  Created by Mike Haydan on 12/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

class WeatherMainInfoTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet private weak var temperatureDataLabel: UILabel!
    
    @IBOutlet private weak var humidityDataLabel: UILabel!
    
    @IBOutlet private weak var presureDataLabel: UILabel!
    
    //MARK: - LifeCycle

    
    //MARK: - Private
    
    
    //MARK: - Public

}

//MARK: - WeatherMainInfoTableViewCellModel

extension WeatherMainInfoTableViewCell: WeatherDetailsCellView {
    func set(model: WeatherDetailsCellModel) {
        let model = model as! Main
        temperatureDataLabel.text = "\(model.temp)"
        humidityDataLabel.text = "\(model.humidity)"
        presureDataLabel.text = "\(model.pressure)"
    }
}
