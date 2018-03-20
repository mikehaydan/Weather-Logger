//
//  LocationServiceSpy.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 18/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
@testable import Weather_Logger

class LocationServiceStub: LocationService {
    
    var locationIsEnabledToBeReturned: Bool!
    
    var resultToBeReturned: (longitude: Double, latitude: Double)?
    
    var delegate: LocationServiceDelegate?
    
    required init(delegate: LocationServiceDelegate?) {
        self.delegate = delegate
    }
    
    var isLocationEnabled: Bool {
        return locationIsEnabledToBeReturned
    }
    
    func prepareLocationService() -> Bool {
        getLocation()
        return locationIsEnabledToBeReturned
    }
    
    func getLocation() {
        if let resultToBeReturned = resultToBeReturned {
                    delegate?.updateLocationWith(longitude: resultToBeReturned.longitude, latitude: resultToBeReturned.latitude)
        }
    }}
