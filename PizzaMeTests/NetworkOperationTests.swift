//
//  NetworkOperationTests.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/16/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import XCTest
@testable import PizzaMe

class NetworkOperationTests: XCTestCase {
    
    var subject: NetworkOperation!
    let session = MockURLSession()
    let urlString = AppConfig().startURL + "11209" + AppConfig().endURL
    
    override func setUp() {
        super.setUp()
        subject = NetworkOperation(url: NSURL(string:urlString)!, session: session)
    }
    
    func test_GET_StartsTheRequest() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        subject.downloadJSONFromURL { (_, _) in
            XCTAssert(dataTask.resumeWasCalled)
        }
    }
    
    //Test if data is valid...in our case we do not know what the data would be since it constantly changes based on location
    /*
    func test_GET_WithResponseData_ReturnsTheData() {
        let expectedData = "{}".dataUsingEncoding(NSUTF8StringEncoding)
        session.nextData = expectedData
        
        var actualData: NSData?
        subject.downloadJSONFromURL { (data, _) in
            actualData = data as? NSData
        }
        XCTAssertEqual(actualData, expectedData)
    }
    */
    
    func test_GET_WithANetworkError_ReturnsANetworkError() {
        session.nextError = NSError(domain: "error", code: 0, userInfo: nil)
        
        var error: ErrorType?
      
        subject.downloadJSONFromURL { (_, theError) in
            error = theError
        }
        
        XCTAssertNotNil(error)
    }
    
    func test_GET_WithAStatusCodeLessThan200_ReturnsAnError() {
        session.nextResponse = NSHTTPURLResponse(URL: NSURL(), statusCode: 199,
                                                 HTTPVersion: nil, headerFields: nil)
        
        var error: ErrorType?
        subject.downloadJSONFromURL { (_, theError) in
            error = theError
        }
        
        XCTAssertNotNil(error)
    }
    
    func test_GET_WithAStatusCodeGreaterThan299_ReturnsAnError() {
        session.nextResponse = NSHTTPURLResponse(URL: NSURL(), statusCode: 300,
                                                 HTTPVersion: nil, headerFields: nil)
        
        var error: ErrorType?
        subject.downloadJSONFromURL { (_, theError) in
            error = theError
        }
        
        
        XCTAssertNotNil(error)
    }
    
    
}
