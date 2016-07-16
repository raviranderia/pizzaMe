//
//  NetworkOperations.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/15/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation


enum NetworkOperationError : ErrorType {
    case ErrorJSON
    case GetRequestNotSuccessful
    case NotValidHTTPResponse
}

protocol NetworkOperationProtocol {
     func downloadJSONFromURL(completion : ([String: AnyObject]?,ErrorType?) -> Void) -> ()
}

class NetworkOperation : NetworkOperationProtocol {
    
    private let session: URLSessionProtocol
//    lazy var configuration : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
//    lazy var session : NSURLSession = NSURLSession(configuration: self.configuration)
    let queryURL : NSURL
    
    
    
    
    required init(url : NSURL,session: URLSessionProtocol = NSURLSession.sharedSession()) {
        self.session = session
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion : ([String: AnyObject]?,ErrorType?) -> Void){
        
        let request: NSURLRequest = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                
                switch(httpResponse.statusCode) {
                case 200:
                    
                    do {
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        completion(jsonDictionary as? [String : AnyObject],nil)
                    }catch {
                        print("error")
                        completion(nil,NetworkOperationError.ErrorJSON)
                        
                    }
                default : print("GET request not successful. HTTP status code : \(httpResponse.statusCode)")
                completion(nil,NetworkOperationError.GetRequestNotSuccessful)
                }
                
                
            }else{
                print("Error : Not a valid HTTP Response")
                completion(nil,NetworkOperationError.NotValidHTTPResponse)
            }
            
        }
        dataTask.resume()
    }
    
}