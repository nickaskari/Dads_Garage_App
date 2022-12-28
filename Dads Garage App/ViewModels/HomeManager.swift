//
//  HomeManager.swift
//  Dads Garage App
//
//  Created by Nick Askari on 12/06/2022.
//

import Foundation
import HomeKit

class HomeManager: NSObject, ObservableObject, HMHomeManagerDelegate {
    private var manager: HMHomeManager
    @Published private(set) var log: [LogObject] = []
    
    override init() {
        manager = HMHomeManager()
        super.init()
        manager.delegate = self
    }
    
    func homeManager(_ manager: HMHomeManager, didUpdate status: HMHomeManagerAuthorizationStatus) {
        checkAuthStatus()
    }
    
    private func checkAuthStatus() {
        switch manager.authorizationStatus {
        case .restricted:
            print(1)
        case .determined:
            print(2)
        case .authorized:
            print(3)
        default:
            print(5)
        }
    }
    
    func getHome() -> HMHome {
        return manager.homes[0]
    }
    
    func hasGarageOpener() -> Bool {
        let home = getHome()
        
            for accessory in home.accessories {
                for service in accessory.services {
                    if service.serviceType == HMServiceTypeGarageDoorOpener {
                        return true
                    }
                }
            }
        
        return false
    }
    
    func readGarageState() -> Bool? {
        let home = getHome()
        
        for accessory in home.accessories {
            for service in accessory.services {
                if service.serviceType == HMServiceTypeGarageDoorOpener {
                    for characteristic in service.characteristics {
                        if characteristic.localizedDescription == "Target Door State" {
                            return characteristic.value as? Bool
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func toggleGarageState(_ state: Bool) {
        let home = getHome()
        
        for accessory in home.accessories {
            for service in accessory.services {
                if service.serviceType == HMServiceTypeGarageDoorOpener {
                    for characteristic in service.characteristics {
                        if characteristic.localizedDescription == "Target Door State" {
                            characteristic.writeValue(NSNumber(value: state)) { error in
                                if error != nil {
                                    print("Something went wrong when attempting to update the service characteristic.")
                                    print(error?.localizedDescription)
                                } else {
                                    self.log.append(LogObject(state: state))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct LogObject: Identifiable {
    let conception: Date
    let state: Bool
    let id = UUID()
    
    init(state: Bool) {
        conception = Date()
        self.state = state
    }
}


