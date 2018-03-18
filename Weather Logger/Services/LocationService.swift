//
//  LocationService.swift
//  Weather Logger
//
//  Created by Mike Haydan on 11/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
import CoreLocation

private struct LocationServiceConstants {
    static let coordsDeltaValue: Double = 10
}

protocol LocationServiceDelegate: class {
    func updateLocationWith(longitude: Double, latitude: Double)
}

protocol LocationService {
    init(delegate: LocationServiceDelegate?)
    var isLocationEnabled: Bool { get }
    func prepareLocationService() -> Bool
}

class LocationServiceImplementation: NSObject, LocationService {
    
    //MARK: - Properties
    
    private let locationManager = CLLocationManager()
    
    private weak var delegate: LocationServiceDelegate?
    
    private var lastCoods: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double.greatestFiniteMagnitude, longitude: Double.greatestFiniteMagnitude)
    
    var isLocationEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    //MARK: - LifeCycle

    required init(delegate: LocationServiceDelegate?) {
        super.init()
        
        self.delegate = delegate
    }
    
    //MARK: - Public
    
    func prepareLocationService() -> Bool {
        locationManager.requestAlwaysAuthorization()
        if isLocationEnabled {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            return true
        } else {
            return false
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension LocationServiceImplementation: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            let longitudeDelta = fabs(location.longitude - lastCoods.longitude)
            let latitudeDelta = fabs(location.latitude - lastCoods.latitude)
            if max(longitudeDelta, latitudeDelta) > LocationServiceConstants.coordsDeltaValue {
                lastCoods = location
                delegate?.updateLocationWith(longitude: location.longitude, latitude: location.latitude)
            }
        }
    }
}
