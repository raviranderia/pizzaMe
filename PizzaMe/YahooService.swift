//
//  YahooService.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/15/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation

//
//  ForecastService.swift
//  weatherApp
//
//  Created by RAVI RANDERIA on 4/5/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

protocol YahooServiceProtocol {
    func getLocalFeed(completion: ([PizzaLocationProtocol]?,ErrorType?) -> (Void)) -> ()
}

enum YahooServiceError : ErrorType {
    case CouldNotConstructValidURL
    case CouldNotParseDataProperly
    case YahooServiceCouldNotBeGenerated
}

import Foundation

struct YahooService : YahooServiceProtocol {
    
    private let networkOperation : NetworkOperationProtocol
    
    init (networkHelper : NetworkOperation) {
        self.networkOperation = networkHelper
    }
        
    func getLocalFeed(completion: ([PizzaLocationProtocol]?,ErrorType?) -> (Void) ){
     
            self.networkOperation.downloadJSONFromURL({ (JSONDictionary,error) in
                
                if JSONDictionary != nil {
                    
                    self.getPizzaLocationList(JSONDictionary, completion: { (pizzaLocation, error) in
                        
                        if error == nil {
                            completion(pizzaLocation,nil)
                        }
                        else{
                            completion(nil,error)
                        }
                    })
                }
                else{
                    
                    completion(nil,error)
                }
                
            })
    }
    
    
    private func getPizzaLocationList(jsonDictionary : [String : AnyObject]?,completion : ([PizzaLocationProtocol]?,ErrorType?)->()){
        
        var pizzaLocationList = [PizzaLocationProtocol]()
        
    
        if let queryResults = jsonDictionary?["query"] as? [String : AnyObject] {
            
        if let pizzaLocationDictionary = queryResults["results"] as? [String: AnyObject]{
            
            if let singlePizzaLocation = pizzaLocationDictionary["Result"] as? [[String:AnyObject]] {
                
                for pizza in singlePizzaLocation {
                    
                    pizzaLocationList.append(PizzaLocation(pizzaDictionary: pizza))
                    
                }
//                print(pizzaLocationList)
                completion(pizzaLocationList,nil)
            }
            else{
                print("not parse properly")
                completion(pizzaLocationList,YahooServiceError.CouldNotParseDataProperly)

            }
        }
        else{
            print("returned nil for results key")
            completion(pizzaLocationList,YahooServiceError.CouldNotParseDataProperly)
        }
        }else{
            print("returned nil for query key")
            completion(pizzaLocationList,YahooServiceError.CouldNotParseDataProperly)
        }
    }
}