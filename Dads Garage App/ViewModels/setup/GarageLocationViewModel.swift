//
//  GarageLocationViewModel.swift
//  Dads Garage App
//
//  Created by Nick Askari on 12/06/2022.
//

import Foundation
import SwiftUI
import MapKit

class GarageSetupViewModel: ObservableObject {
    @ObservedObject var locManager: LocationManager
    @Published var mapRegion: MKCoordinateRegion
    @Published var userTrackingMode: MapUserTrackingMode = .follow
    
    init(_ locManager: LocationManager) {
        self.locManager = locManager
        self.mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: locManager.location?.latitude ?? 63, longitude: locManager.location?.longitude ?? 10),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    }
    
}
