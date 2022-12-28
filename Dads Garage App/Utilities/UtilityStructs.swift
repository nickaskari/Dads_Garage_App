//
//  UtilityStructs.swift
//  Dads Garage App
//
//  Created by Nick Askari on 12/06/2022.
//

import Foundation
import SwiftUI

struct PoppingButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.10 : 1.0)
    }
}
