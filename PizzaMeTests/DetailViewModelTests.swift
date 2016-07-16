//
//  DetailViewModelTests.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/16/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import XCTest
@testable import PizzaMe

class DetailViewModelTests: XCTestCase {

    let parser = DetailViewModel()

    func testParsePhoneNumber(){
       let phoneNumbers = ["+1(929)-253-2101","+1 (217)-721-8431","213-321-7885"]
        let expectsAnswers = ["19292532101","12177218431","2133217885"]
        
        for i in 0..<phoneNumbers.count {
            XCTAssertEqual(parser.parsePhoneNumber(phoneNumbers[i]), expectsAnswers[i])
        }
    }

}
