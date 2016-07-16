//
//  AppConfig.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/16/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation

class AppConfig {
    
    var startURL = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20local.search%20where%20zip%3D'"
    var endURL = "'%20and%20query%3D'pizza'&format=json&diagnostics=true&callback="
}