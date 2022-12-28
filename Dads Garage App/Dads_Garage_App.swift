//
//  Dads_Garage_AppApp.swift
//  Dads Garage App
//
//  Created by Nick Askari on 11/06/2022.
//

import SwiftUI

@main
struct Dads_Garage_App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .onAppear {
                    portraitOrientationLock()
                }
        }
    }
}
