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
    
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet private weak var detailsButton: UIButton!
    
    var presenter: WeatherListCellPresenter!
    
    //MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        presenter = WeatherListCellPresenterImplementation(view: self)
    }
    
    //MARK: - IBActions
    
    @IBAction private func detailsButtonTapped(_ sender: Any) {
        presenter.detailsButtonTapped()
    }
    
    //MARK: - Private
    
    
    
    //MARK: - Public
    
    func set(temperature: String, andDate date: String) {
        temperatureLabel.text = temperature
        dateLabel.text = date
    }

    func set(detailsButtonText: String) {
        detailsButton.setTitle(detailsButtonText, for: .normal)
    }
}
