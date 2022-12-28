//
//  WelcomeView.swift
//  Dads Garage App
//
//  Created by Nick Askari on 12/06/2022.
//

import SwiftUI

struct WelcomeView: View {
    @State private var mapIsPresented: Bool = false
    @State private var error: Bool = false
    @EnvironmentObject private var locManager: LocationManager
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 90) {
                HStack {
                    Text("Welcome to Dads Garage Opener!")
                        .font(.largeTitle.bold())
                    .padding()
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "homekit")
                        .font(.system(size: 60))
                        .foregroundColor(error == true ? .black : .yellow)
                    Image(systemName: "key")
                        .font(.system(size: 80))
                    Image(systemName: "location")
                        .font(.system(size: 60))
                        .foregroundColor(error == true ? .black : .blue)
                }
                
                Text("In order for this to work permission must be granted to use your location and to access Homekit")
                    .padding()
                    .opacity(0.7)
                
                Spacer()
            }
            VStack(spacing: 100) {
                if error {
                    withAnimation {
                        errorView
                    }
                }
                nextButton
            }
        }
        .onAppear {
            locManager.checkIfLocationServicesIsEnabled()
        }
    }
    
    var nextButton: some View {
        Button {
            if !locManager.error {
                mapIsPresented = true
            } else {
                self.error = true
            }
        } label: {
            Text("Next")
                .capsuleStyle(.black)
        }
        .buttonStyle(PoppingButtonStyle())
        .fullScreenCover(isPresented: $mapIsPresented) {
            ShowGarageLocationView(garageLoc: GarageSetupViewModel(locManager))
        }
    }
    
    var errorView: some View {
        Text("Location is not enabled, go to your settings")
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
            .foregroundColor(.white)
            .background(Capsule().opacity(0.6))
    }
}









struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
