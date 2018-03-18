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
    
    var isLocationPrepared = false
    
    var delegate: LocationServiceDelegate?
    
    required init(delegate: LocationServiceDelegate?) {
        self.delegate = delegate
    }
    
    var isLocationEnabled: Bool {
        return isLocationPrepared
    }
    
    func prepareLocationService() -> Bool {
        isLocationPrepared = true
        return isLocationPrepared
    }
    
    
}
