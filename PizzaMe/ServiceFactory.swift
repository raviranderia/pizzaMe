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
    
    private func generateURL(zip : String,completion : (NSURL?,ErrorType?) -> ()) {
        
        let urlString = AppConfig().startURL + zip + AppConfig().endURL
        if let returnString = NSURL(string: urlString){
            completion(returnString,nil)
        }
        else{
            completion(nil,YahooServiceError.CouldNotConstructValidURL)
        }
    }
    
    //getLocationFromLocationServices
    private func getZip(completion : (String?,ErrorType?)-> ()){
        
        self.locationService.getCurrentLocation({ (zip, error) in
            if zip != nil {
                completion(zip,nil)
            }
            else{
                completion(nil,error)
            }
        })
    }
    
    
    
    

    
    func pizzaListViewModel(completion : (PizzaListViewModel?,ErrorType?)->())  {
        
        self.yahooService { (yahoo, yahooError) in
            
            if let yahoo = yahoo {
                completion(PizzaListViewModel(yahoo: yahoo),nil)
            }
            else{
                completion(nil,yahooError)
            }
            
        }
    }
    
    var locationService: LocationServices {
        return LocationServices()
    }
    
    func networkOperation(url : NSURL,completion : (NetworkOperation?,ErrorType?)->()) {
        completion(NetworkOperation(url: url),nil)
    }
    
    var detailViewModel : DetailViewModelProtocol {
        return DetailViewModel()
    }
    
    
    func yahooService(completion : (YahooService?,ErrorType?) -> ()) {
        self.getZip { (zipCode, error) in
            if let zipCode = zipCode {
                self.generateURL(zipCode, completion: { (url, urlError) in
                    if let url = url {
                       self.networkOperation(url, completion: { (networkHelper, networkError) in
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