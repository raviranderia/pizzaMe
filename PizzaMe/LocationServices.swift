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
    func getCurrentLocation(completion : (String?,ErrorType?) -> () )
}

enum LocationError : ErrorType {
    case NotAuthorized
    case LocationServicesDisabled
    case ProblemFindindZipCode
}



class LocationServices : LocationServiceProtocol {
    
    private var locationManager = CLLocationManager()
    private var reverseGeoCoder = CLGeocoder()
    
    
    func requestForLocationServices(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation(completion : (String?,ErrorType?) -> () )  {
        
        self.requestForLocationServices()
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            if let currentLocation = locationManager.location {
               
                self.geoCodeLocation(currentLocation, completion: { (zipCode) in
                    
                    if zipCode != nil {
                         completion(zipCode,nil)
                    }
                    else{
                        print("could not geocode")
                        completion(nil,LocationError.ProblemFindindZipCode)
                    }
                })
                
            }
            else{
                print("authrorized but location services off")
                completion(nil,LocationError.LocationServicesDisabled)
            }
        }
        else{
            print("not authorized")
            completion(nil,LocationError.NotAuthorized)
        }
    }
    
    private func geoCodeLocation(currentLocation : CLLocation,completion : (String?) -> ()) {
        
        reverseGeoCoder.reverseGeocodeLocation(currentLocation) { (address, error) in
            if error ==  nil {
                if let zipCode = address?.first?.postalCode {
                    completion(zipCode)
                }
                else{
                    completion(nil)
                }
            }
            else{
                completion(nil)
            }
        }
    }

}