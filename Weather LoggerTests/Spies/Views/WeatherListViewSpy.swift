//
//  WeatherListViewSpy.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 18/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
@testable import Weather_Logger

class WeatherListViewSpy: WeatherListView {
    
    var showedMessage: String!
    var retryText: String!
    var isViewReloaded = false
    var isProgressShowed = false
    var isProgressHide = false
    var isViewReloadedAnimated = false
    var isDetailsShowed = false
    var callRetryHandler = false
    
    func show(message: String) {
        showedMessage = message
    }
    
    func showWithRetry(message: String, retryText: String, retryHandler: @escaping () -> ()) {
        showedMessage = message
        self.retryText = retryText
        if callRetryHandler {
            callRetryHandler = false
            retryHandler()
        }
    }
    
    func reloadView() {
        isViewReloaded = true
    }
    
    func showProgres() {
        isProgressShowed = true
    }
    
    func hideProgres() {
        isProgressHide = true
    }
    
    func showDetailsViewWith(model: WeatherModel, forView view: WeatherDetailsView) {
        isDetailsShowed = true
    }
    
    func reloadViewAnimated() {
        isViewReloadedAnimated = true
    }
    
    
}
