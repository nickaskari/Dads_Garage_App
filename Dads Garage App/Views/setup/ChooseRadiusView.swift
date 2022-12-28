//
//  ChooseRadiusView.swift
//  Dads Garage App
//
//  Created by Nick Askari on 13/06/2022.
//

import SwiftUI

struct ChooseRadiusView: View {
    @State private var mainViewIsPresented = false
    @State private var radius = 50.0
    @State private var isEditing = false
    
    @AppStorage("radius") var storedRadius: Double?
    @AppStorage("didSetup") var didSetup: Bool?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 150) {
                VStack(spacing: 20){
                    Text("How far from your garage do you want to open and close the door?")
                        .font(.headline)
                        .padding(.horizontal)
                    Text("This can also be changed later")
                        .font(.subheadline)
                        .opacity(0.6)
                }
                
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
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    nextButton
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var nextButton: some View {
        Button  {
            self.mainViewIsPresented = true
            storedRadius = radius
            didSetup = true
        } label: {
            Text("Next")
                .nextButtonStyle()
        }
        .buttonStyle(PoppingButtonStyle())
        .fullScreenCover(isPresented: $mainViewIsPresented) {
            DadsGarageOpener()
        }
    }
    
    private func formatRadius() -> String {
        let formated = round(10 * radius) / 10
        return "\(formated) m"
    }
}







struct ChooseRadiusView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseRadiusView()
    }
}
