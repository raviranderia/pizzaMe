//
//  MockURLSession.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/16/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation


typealias DataTaskResult = (NSData?, NSURLResponse?, NSError?) -> Void

extension NSURLSession: URLSessionProtocol {

    func dataTaskWithRequest(url: NSURLRequest, completionHandler: DataTaskResult)
        -> URLSessionDataTaskProtocol
    {
        return (dataTaskWithRequest(url, completionHandler: completionHandler)
            as NSURLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

protocol URLSessionProtocol {

    func dataTaskWithRequest(url: NSURLRequest, completionHandler: DataTaskResult)
        -> URLSessionDataTaskProtocol
}

class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData : NSData?
    var nextError : NSError?
    var nextResponse : NSURLResponse?
    
    private (set) var lastURL: NSURLRequest?
    
    func dataTaskWithRequest(url: NSURLRequest, completionHandler: DataTaskResult)
        -> URLSessionDataTaskProtocol
    {
        lastURL = url
        completionHandler(nextData, nextResponse, nextError)
        return nextDataTask
    }
    
}