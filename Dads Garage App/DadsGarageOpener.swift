//
//  ContentView.swift
//  Dads Garage App
//
//  Created by Nick Askari on 11/06/2022.
//

import SwiftUI

struct DadsGarageOpener: View {
    @EnvironmentObject private var locManager: LocationManager
    @AppStorage("disableAuto") private var disableAuto: Bool = false
    
    var body: some View {
        TabView {
            LogView()
                .tabItem {
                    Label("Log", systemImage: "line.3.horizontal.decrease.circle.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .onAppear {
            locManager.checkIfLocationServicesIsEnabled()
            if disableAuto == false {
                locManager.startMonitoringGarage()
                locManager.allowBackroundTracking()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DadsGarageOpener()
    }
}
