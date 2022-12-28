//
//  UtilityExtensions.swift
//  Dads Garage App
//
//  Created by Nick Askari on 12/06/2022.
//

import Foundation
import SwiftUI

extension Text {
    func capsuleStyle(_ color: Color) -> some View {
        self
            .padding(EdgeInsets(top: 20, leading: 60, bottom: 20, trailing: 60))
            .foregroundColor(.white)
            .background(Capsule().foregroundColor(color))
            .shadow(radius: 5)
    }
    
    func nextButtonStyle() -> some View {
        self
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .foregroundColor(.white)
            .background(Capsule().foregroundColor(.blue))
            .shadow(radius: 5)
    }
}

extension VStack {
    func capsuleStyle(_ color: Color) -> some View {
        self
            .padding(EdgeInsets(top: 20, leading: 60, bottom: 20, trailing: 60))
            .foregroundColor(.white)
            .background(Capsule().foregroundColor(color))
            .shadow(radius: 5)
    }
}
