//
//  ChangeRadiusView.swift
//  Dads Garage App
//
//  Created by Nick Askari on 13/06/2022.
//

import SwiftUI

struct ChangeRadiusView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var locManager: LocationManager
    
    @State private var radius: Double = 50.0
    @State private var isEditing = false
    
    @AppStorage("radius") var savedRadius: Double?
    
    
    var body: some View {
        VStack(spacing: 150) {
            Spacer()
            
            VStack {
                Text(formatRadius())
                    .foregroundColor(isEditing ? .pink : .white)
                Slider(value: $radius,
                       in: 10...500) { editing in
                            isEditing = editing
                }
            }
            .capsuleStyle(.black)
            .padding(40)
            
            
            saveButton
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Change radius")
                    .font(.headline)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            if let savedRadius = savedRadius {
                self.radius = savedRadius
            }
        }
    }
    
    private var saveButton: some View {
        Button {
            savedRadius = radius
            locManager.startMonitoringGarage()
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Save")
                .capsuleStyle(.blue)
        }
        .buttonStyle(PoppingButtonStyle())

    }
    
    
    private func formatRadius() -> String {
        let formated = round(10 * radius) / 10
        return "\(formated) m"
    }
}










struct ChangeRadiusView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeRadiusView()
    }
}
