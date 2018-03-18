//
//  LocationServices.swift
//  weatherApp
//
//  Created by RAVI RANDERIA on 4/5/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func getCurrentLocation(completion : @escaping (String?, Error?) -> Void)
}

enum LocationError : Error {
    case NotAuthorized
    case LocationServicesDisabled
    case ProblemFindindZipCode
}

class LocationServices : NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    private var reverseGeoCoder = CLGeocoder()
    private var requestAuthorizationCompletion: ((String?, Error?) -> Void)?
    
    static var shared = LocationServices()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestForLocationServices(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation(completion : @escaping (String?, Error?) -> Void) {
        requestAuthorizationCompletion = completion
        self.requestForLocationServices()
    }
    
    private func geoCodeLocation(currentLocation : CLLocation, completion : @escaping (String?) -> Void) {
        reverseGeoCoder.reverseGeocodeLocation(currentLocation) { (address, error) in
            if error ==  nil {
                if let zipCode = address?.first?.postalCode {
                    completion(zipCode)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            requestAuthorizationCompletion?(nil,LocationError.NotAuthorized)
        } else if status == .authorizedWhenInUse {
            if let currentLocation = locationManager.location {
                self.geoCodeLocation(currentLocation: currentLocation) { (zipCode) in
                    if zipCode != nil {
                        self.requestAuthorizationCompletion?(zipCode,nil)
                    } else {
                        print("could not geocode")
                        self.requestAuthorizationCompletion?(nil,LocationError.ProblemFindindZipCode)
                    }
                }
            } else {
                print("authrorized but location services off")
                requestAuthorizationCompletion?(nil,LocationError.LocationServicesDisabled)
            }
        }
    }
}
