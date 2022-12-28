//
//  SplashView.swift
//  Dads Garage App
//
//  Created by Nick Askari on 12/06/2022.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive: Bool = false
    @StateObject private var locManager = LocationManager()
    
    @FetchRequest(sortDescriptors: []) var logFeed: FetchedResults<LogFeed>
    @Environment(\.managedObjectContext) var moc
    
    @AppStorage("didSetup") var didSetup: Bool = false
    
    var body: some View {
        if isActive {
            if didSetup {
                DadsGarageOpener()
                    .environmentObject(locManager)
            } else {
                WelcomeView()
                    .environmentObject(locManager)
            }
        } else {
            HStack {
                Text("Dads\nGarage Opener")
                    .font(.largeTitle.bold())
                
                Image(systemName: "key")
                    .font(.system(size: 50))
            }
            .padding()
            .onAppear {
                for log in logFeed {
                    moc.delete(log)
                }
                try? moc.save()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeIn(duration: 0.2)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
