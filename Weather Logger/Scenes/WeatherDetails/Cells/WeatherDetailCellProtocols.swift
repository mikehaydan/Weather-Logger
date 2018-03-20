//
//  WeatherDetailCellProtocols.swift
//  Weather Logger
//
//  Created by Mike Haydan on 12/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

protocol WeatherDetailsCellModel {
    var cellIdentifier: String { get }
    var model: Any { get }
    init(model: Any, cellIdentifier: String)
}

protocol WeatherDetailsCellView {
    func set(model: WeatherDetailsCellModel)
}

struct WeatherWeatherDetailsCellModelImplementation: WeatherDetailsCellModel {
    var cellIdentifier: String
    
    var model: Any
    
    init(model: Any, cellIdentifier: String) {
        self.model = model
        self.cellIdentifier = cellIdentifier
    }
}


//MARK: - BaseWeatherDetailsTableViewCell

class BaseWeatherDetailsTableViewCell: UITableViewCell, WeatherDetailsCellView {
    
    func set(model: WeatherDetailsCellModel) {
        
    }
}
