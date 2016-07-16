//
//  PizzaLocation.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/15/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation
import UIKit

protocol PizzaLocationProtocol {
    
    var title : String? {get}
    var address : String? {get}
    var city: String?{get}
    var state: String?{get}
    var phone: String?{get}
    var latitude : String?{get}
    var longitude : String?{get}
    var distance : Float?{get}
    var mapURL : String?{get}
    var clickURL : String?{get}
    var businessURL : String?{get}
    var rating : [String : Int]?{get}
}

struct PizzaLocation : PizzaLocationProtocol {
    
    let title: String?
    let address : String?
    let city: String?
    let state: String?
    let phone: String?
    let latitude : String?
    let longitude : String?
    let distance : Float?
    let mapURL : String?
    let clickURL : String?
    let businessURL : String?
    let rating : [String : Int]?
    
    init(pizzaDictionary: [String : AnyObject]) {
        
        self.title = pizzaDictionary["Title"] as? String
        
        if let address = pizzaDictionary["Address"] as? String {
            self.address = address
        }
        else{
            self.address = nil
        }
        
        if let city = pizzaDictionary["City"] as? String {
            self.city = city
        }
        else{
            self.city = nil
        }
        
        if let state = pizzaDictionary["State"] as? String {
            self.state = state
        }
        else{
            self.state = nil
        }
        
        if let phoneNumber = pizzaDictionary["Phone"] as? String {
            self.phone = phoneNumber
        }
        else{
            self.phone = nil
        }
       
        if let latitude = pizzaDictionary["Latitude"] as? String {
            self.latitude = (latitude)
        }
        else{
            self.latitude = nil
        }
       
        if let longitude = pizzaDictionary["Longitude"] as? String {
            self.longitude = (longitude)
        }
        else{
            self.longitude = nil
        }
    
        if let distance = pizzaDictionary["Distance"] as? String {
            self.distance = Float(distance)
        }
        else{
            self.distance = nil
        }
        if let mapURL = pizzaDictionary["MpUrl"] as? String {
            self.mapURL = mapURL
        }
        else{
            self.mapURL = nil
        }
        
        if let clickURL = pizzaDictionary["ClickUrl"] as? String {
            self.clickURL = clickURL
        }
        else{
            self.clickURL = nil
        }
        
        if let businessURL = pizzaDictionary["BusinessUrl"] as? String {
            self.businessURL = businessURL
        }
        else{
            self.businessURL = nil
        }
        
        if let rating = pizzaDictionary["Rating"] as? [String:Int] {
            self.rating = rating
        }
        else{
            self.rating = nil
        }
        
        
       
        
  
    }

}