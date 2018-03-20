//
//  WeatherDetailsViewSpy.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 18/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
@testable import Weather_Logger

class WeatherDetailsViewSpy: WeatherDetailsView {
    
    var isDeailsReloaded: Bool = false
    var titleDsiplayed: String?
    var messageDisplayed = ""
    var isSaveEnabled: Bool!
    var emulateTableView = false
    
    var cells: [String: WeatherDetailsCellView] = [:]
    
    var presenter: WeatherDetailsPresenter!
    
    func reloadDetails() {
        isDeailsReloaded = true
        
        if emulateTableView {
            for i in 0..<presenter.dataSourceCount {
                cellForRowAt(index: i)
            }
        }
    }
    
    func set(title: String?) {
        titleDsiplayed = title
    }
    
    func show(message: String) {
        messageDisplayed = message
    }
    
    func save(enabled: Bool) {
        isSaveEnabled = enabled
    }
    
    func cellForRowAt(index: Int) {
        let identifier = presenter.getCellIdentifierAt(index: index)
        let cell = cells[identifier]!
        presenter.configure(view: cell, atIndex: index)
    }
}
