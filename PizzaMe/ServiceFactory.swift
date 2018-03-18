//
//  SeriveFactory.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/16/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation


class ServiceFactory {
    
    
    //generate URL for yahooAPI
    
    private func generateURL(zip : String,completion : (URL?, Error?) -> Void) {
        
        let urlString = AppConfig().startURL + zip + AppConfig().endURL
        if let returnString = URL(string: urlString){
            completion(returnString, nil)
        }
        else{
            completion(nil,YahooServiceError.CouldNotConstructValidURL)
        }
    }
    
    //getLocationFromLocationServices
    private func getZip(completion : @escaping (String?, Error?) -> Void) {
        self.locationService.getCurrentLocation { (zip, error) in
            if zip != nil {
                completion(zip,nil)
            } else {
                completion(nil,error)
            }
        }
    }
    
    func pizzaListViewModel(completion : @escaping (PizzaListViewModel?, Error?) -> Void) {
        
        self.yahooService { (yahoo, yahooError) in
            
            if let yahoo = yahoo {
                completion(PizzaListViewModel(yahoo: yahoo),nil)
            } else {
                completion(nil,yahooError)
            }
        }
    }
    
    var locationService: LocationServices {
        return LocationServices.shared
    }
    
    func networkOperation(url : URL,completion : (NetworkOperation?, Error?) -> Void) {
        completion(NetworkOperation(url: url), nil)
    }
    
    var detailViewModel : DetailViewModelProtocol {
        return DetailViewModel()
    }
    
    func yahooService(completion: @escaping (YahooService?, Error?) -> Void) {
        self.getZip { (zipCode, error) in
            if let zipCode = zipCode {
                self.generateURL(zip: zipCode, completion: { (url, urlError) in
                    if let url = url {
                        self.networkOperation(url: url, completion: { (networkHelper, networkError) in
                            if let networkHelper = networkHelper {
                                completion(YahooService(networkHelper: networkHelper),nil)
                            }
                            else{
                                completion(nil,networkError)
                            }
                        })
                    }
                    else{
                        completion(nil,urlError)
                    }
                })
            }
            else{
                completion(nil,error)
            }
        }
        
    }
}
