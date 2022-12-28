//
//  ProfileView.swift
//  Dads Garage App
//
//  Created by Nick Askari on 13/06/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var locManager: LocationManager
    
    @AppStorage("disableAuto") private var disableAuto: Bool = false
    @State private var showSwitchAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                changeRadius
                
                Divider()
                    .padding(.horizontal)
                
                disableTrackingSwitch
                
                Divider()
                    .padding(.horizontal)
                
                Spacer()
                
                if showSwitchAlert {
                    switchAlert
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Profile")
                        .font(.headline)
                }
            }
        }
    }
    
    private var changeRadius: some View {
        NavigationLink {
            ChangeRadiusView()
        } label: {
            HStack {
                Text("Change radius")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 15))
                    .padding(.horizontal)
            }
        }
    }
    
    private var disableTrackingSwitch: some View {
        Toggle(isOn: $disableAuto) {
            Text("Disable automatic open / close")
                .font(.headline)
                .foregroundColor(.black)
        }
        .padding(.horizontal)
        .toggleStyle(SwitchToggleStyle(tint: .blue))
        .onChange(of: disableAuto) { newValue in
            if newValue {
                locManager.disableBackroundTracking()
                locManager.stopMonitoringGarage()
                withAnimation {
                    showSwitchAlert = true
                }
            } else {
                locManager.allowBackroundTracking()
                locManager.startMonitoringGarage()
                withAnimation {
                    showSwitchAlert = false
                }
            }
        }
    }
    
    private var switchAlert: some View {
        Text("Auto open / close is disabled")
            .capsuleStyle(.black.opacity(0.8))
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSwitchAlert = false
                    }
                }
            }
    }
    
    
}












struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
