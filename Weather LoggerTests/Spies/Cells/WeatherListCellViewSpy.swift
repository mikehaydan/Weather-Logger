//
//  WeatherListCellViewSpy.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 18/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

@testable import Weather_Logger

class WeatherListCellViewSpy: WeatherListCellView {
    
    var presenter: WeatherListCellPresenter!
    
    var velocityValue: CGPoint!
    
    var velocityInView: CGPoint {
        return velocityValue
    }
    
    var temperatureDisplayed = ""
    var dateDisplayed = ""
    var detailsButtonTextDisplayed = ""
    var gestureConfigured: Bool = false
    var deleteConstraintValue: CGFloat!
    var gestureEnabled: Bool!
    var viewReloaded: Bool = false
    
    func set(temperature: String, andDate date: String) {
        temperatureDisplayed = temperature
        dateDisplayed = date
    }
    
    func set(detailsButtonText: String) {
        detailsButtonTextDisplayed = detailsButtonText
    }
    
    func prepareGesture() {
        gestureConfigured = true
    }
    
    func setDeleteButtonConstraintWith(value: CGFloat) {
        deleteConstraintValue = value
    }
    
    func reloadViewAnimated() {
        viewReloaded = true
    }
    
    func setGesture(enabled: Bool) {
        gestureEnabled = enabled
    }
}
