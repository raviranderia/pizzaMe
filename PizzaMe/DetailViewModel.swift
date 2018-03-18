//
//  DetailViewModel.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/16/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit


protocol DetailViewModelProtocol {
    func openMapForPlace(lat : String,long:String,venueName : String) -> ()
    func parsePhoneNumber(number : String) -> String?
}

class DetailViewModel : DetailViewModelProtocol {
    
    
    func openMapForPlace(lat : String,long:String,venueName : String) {
        
        let lat1 : NSString = lat as NSString
        let lng1 : NSString = long as NSString
        
        let latitute:CLLocationDegrees =  lat1.doubleValue
        let longitute:CLLocationDegrees =  lng1.doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(venueName)"
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    func parsePhoneNumber(number : String) -> String? {
        return removeSpecialCharsFromString(text: number)
    }
    
    private func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> = Set("1234567890")
        return String(text.filter { okayChars.contains($0) })
    }
}
