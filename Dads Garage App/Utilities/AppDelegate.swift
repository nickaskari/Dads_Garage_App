//
//  AppDelegate.swift
//  Dads Garage App
//
//  Created by Nick Askari on 13/06/2022.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
