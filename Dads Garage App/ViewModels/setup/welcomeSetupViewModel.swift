//
//  SetupViewModel.swift
//  Dads Garage App
//
//  Created by Nick Askari on 12/06/2022.
//

import Foundation

class welcomeSetupViewModel: ObservableObject {
    @Published var locationIsOn: Bool = false
    @Published var homeKitEnabled: Bool = false
}
