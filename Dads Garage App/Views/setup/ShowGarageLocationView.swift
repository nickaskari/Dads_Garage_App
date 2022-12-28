//
//  ChooseGarageLocationView.swift
//  Dads Garage App
//
//  Created by Nick Askari on 12/06/2022.
//

import SwiftUI
import MapKit

struct ShowGarageLocationView: View {
    @EnvironmentObject private var locManager: LocationManager
    @ObservedObject var garageLoc: GarageSetupViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var sliderIsPresented = false
    @AppStorage("lat") var lat: Double?
    @AppStorage("lon") var lon: Double?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $garageLoc.mapRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: $garageLoc.userTrackingMode)
                    .edgesIgnoringSafeArea(.all)
                
                infoView
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
                ToolbarItem(placement: .confirmationAction) {
                    nextButton
                }
            }
        }
    }
    
    var cancelButton: some View {
        Button  {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(.white)
                .padding(5)
                .background(Circle().foregroundColor(.black))
                .font(.system(size: 15))
        }
    }
    
    var nextButton: some View {
        Button  {
            lat = locManager.location!.latitude
            lon = locManager.location!.longitude
            
            self.sliderIsPresented = true
        } label: {
            Text("Next")
                .nextButtonStyle()
        }
        .buttonStyle(PoppingButtonStyle())
        .fullScreenCover(isPresented: $sliderIsPresented) {
            ChooseRadiusView()
        }
    }
    
    var infoView: some View {
        Text("The app will use your current location as your garage location")
            .font(.caption)
            .capsuleStyle(.black)
            .padding(50)
    }
}


