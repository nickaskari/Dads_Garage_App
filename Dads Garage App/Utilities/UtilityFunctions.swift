//
//  UtilityFunctions.swift
//  Dads Garage App
//
//  Created by Nick Askari on 12/06/2022.
//

import Foundation
import MapKit

func distance(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) -> Double {
    
    let lon1: Double = loc1.longitude * (Double.pi / 180)
    let lon2: Double = loc2.longitude * (Double.pi / 180)
    let lat1: Double = loc1.latitude * (Double.pi / 180)
    let lat2: Double = loc2.latitude * (Double.pi / 180)
    
    // Haversine formula
    let dlon = lon2 - lon1
    let dlat = lat2 - lat1
    let a = pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2)
           
    let c = 2 * asin(sqrt(a))
    
    // Radius of earth in meters
    let r: Double = 6371000
          
    // calculate the result
    let result: Double = c * r
    return result
}

func portraitOrientationLock() {
    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    AppDelegate.orientationLock = .portrait
}
