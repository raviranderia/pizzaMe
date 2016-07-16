//
//  PizzaListViewModel.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/15/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation



protocol PizzaListViewModelProtocol {
    init(yahoo: YahooServiceProtocol)
    func retrievePizzaList(completion : ([PizzaLocationProtocol]?,ErrorType?) -> () )
}


class PizzaListViewModel : PizzaListViewModelProtocol {
    
    let yahooService : YahooServiceProtocol?
    
    private var pizzaList = [PizzaLocationProtocol]()
    private var currentZipCode = String()
    
    
    required init(yahoo:YahooServiceProtocol) {
        self.yahooService = yahoo
    }

    
    func retrievePizzaList(completion : ([PizzaLocationProtocol]?,ErrorType?) -> () )  {
               
                if let yahooService = self.yahooService {
                yahooService.getLocalFeed({ (pizzaLocationList,error) -> (Void) in
                    
                    if let pizzaList = pizzaLocationList {
                        completion(pizzaList,nil)
                    }
                    else{
                        completion(nil,error)
                    }
                
                })
                }
                else{
                    completion(nil,YahooServiceError.YahooServiceCouldNotBeGenerated)
        }
        
    }
           
    
}
