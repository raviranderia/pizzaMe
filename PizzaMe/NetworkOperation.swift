//
//  NetworkOperations.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/15/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation


enum NetworkOperationError : Error {
    case ErrorJSON
    case GetRequestNotSuccessful
    case NotValidHTTPResponse
}

protocol NetworkOperationProtocol {
    func downloadJSONFromURL(completion : @escaping ([String: AnyObject]?, Error?) -> Void)
}

class NetworkOperation : NetworkOperationProtocol {
    
    private let session: URLSession
//    lazy var configuration : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
//    lazy var session : NSURLSession = NSURLSession(configuration: self.configuration)
    let queryURL : URL
    
    required init(url : URL,
                  session: URLSession = URLSession.shared) {
        self.session = session
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion : @escaping ([String: AnyObject]?, Error?) -> Void) {
        let request: URLRequest = URLRequest(url: queryURL as URL)
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                
                switch(httpResponse.statusCode) {
                case 200:
                    
                    do {
                        let jsonDictionary = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
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
