//
//  LocationManager.swift
//  Dads Garage App
//
//  Created by Nick Askari on 12/06/2022.
//

import Foundation
import MapKit
import ObjectiveC
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var manager: CLLocationManager?
    private(set) var location: CLLocationCoordinate2D?
    private(set) var error: Bool = false
    @Published private(set) var isInZone: Bool = true {
        didSet {
            if let garageState = homeManager.readGarageState() {
                homeManager.toggleGarageState(!garageState)
            }
        }
    }
    
    @Published private(set) var userLocationDescription: String?

    
    @ObservedObject var homeManager = HomeManager()
    
    @AppStorage("lat") private var lat: Double?
    @AppStorage("lon") private var lon: Double?
    @AppStorage("radius") private var radius: Double?
    @AppStorage("disableAuto") private var disableAuto: Bool = false
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            manager = CLLocationManager()
            manager!.delegate = self
        } else {
            error = true
        }
    }
    
    func updateLocation() {
        if let manager = manager {
            manager.startUpdatingLocation()
        }
    }
    
    func startMonitoringGarage() {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            if let garageLoc = garageLocation() {
                if let radius = radius {
                    let region = CLCircularRegion(center: garageLoc, radius: radius, identifier: "Garage Zone")
                    region.notifyOnEntry = true
                    region.notifyOnExit = true
                    
                    manager?.startMonitoring(for: region)
                }
            }
        }
    }
    
    func stopMonitoringGarage() {
        if let manager = manager {
            for region in manager.monitoredRegions {
                manager.stopMonitoring(for: region)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
            self.userLocationDescription = "You are inside the garage zone"
            print("Is inside " + region.identifier)
        case .outside:
            self.userLocationDescription = "You are outeside the garage zone"
            print("Is outside " + region.identifier)
        case .unknown:
            self.userLocationDescription = "Some error has occured :("
            print("Unknown whether the user is inside or outside " + region.identifier)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let state = homeManager.readGarageState() {
            if state {
                homeManager.toggleGarageState(false)
                triggerLocalNotification(subTitle: "User Entered", body: "Garage will now open")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let state = homeManager.readGarageState() {
            if !state {
                homeManager.toggleGarageState(true)
                triggerLocalNotification(subTitle: "User Exited", body: "Garage will now close")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first?.coordinate
        /*if !disableAuto {
            checkUserIsInZone()
        }
        print(isInZone)*/
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func disableBackroundTracking() {
        manager?.allowsBackgroundLocationUpdates = false
        manager?.pausesLocationUpdatesAutomatically = true
    }
    
    func allowBackroundTracking() {
        manager?.allowsBackgroundLocationUpdates = true
        manager?.pausesLocationUpdatesAutomatically = false
    }
    
    private func checkLocationAuthorization() {
        guard let manager = manager else { return }

        switch manager.authorizationStatus {
        case .notDetermined:
            manager.allowsBackgroundLocationUpdates = false
            manager.requestWhenInUseAuthorization()
        case .restricted:
            self.error = true
        case .denied:
            self.error = true
        case .authorizedAlways, .authorizedWhenInUse:
            allowBackroundTracking()
            self.error = false
            updateLocation()
        @unknown default:
            self.error = true
        }
        
    }
    
    private func garageLocation() -> CLLocationCoordinate2D? {
        if lat != nil && lon != nil {
            return CLLocationCoordinate2D(latitude: lat!,
                                          longitude: lon!)
        } else {
            return nil
        }
    }
    
    private func checkUserIsInZone() {
        if garageLocation() != nil && self.location != nil && radius != nil {
            if distance(loc1: garageLocation()!, loc2: location!) > radius! {
                if isInZone == true {
                    self.isInZone = false
                }
            } else {
                if isInZone == false {
                    self.isInZone = true
                }
            }
        }
    }
    
    private func triggerLocalNotification(subTitle: String, body: String) {
        // configure notification content
        let content = UNMutableNotificationContent()
        content.title = "Alert!"
        content.subtitle = subTitle
        content.body = body
        content.sound = UNNotificationSound.default
        
        // setup trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // create request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add notification request
        UNUserNotificationCenter.current().add(request)
    }
}
