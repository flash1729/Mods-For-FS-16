//
//  DeleteItemAlert.swift
//  Farming Simulator 2022
//
//  Created by Sim on 01/10/24.
//

import SwiftUI

struct DeleteConfirmationAlertView: View {
    @State var stateTapped: (Bool) -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    stateTapped(false)
                }
            
            VStack(spacing: 12) {
                Text("This action will remove your all changes")
                    .font(FontTurboGear.gilroyStyle(size: bigSize ? 28 : 20, type: .semibold))
                    .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                
                // OK Button
                Button {
                    stateTapped(true)
                } label: {
                    Text("OK")
                        .font(FontTurboGear.gilroyStyle(size: bigSize ? 24 : 18, type: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(ColorTurboGear.colorPicker(.darkGreen))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                
                // Cancel Button
                Button {
                    stateTapped(false)
                } label: {
                    Text("Cancel")
                        .font(FontTurboGear.gilroyStyle(size: bigSize ? 24 : 18, type: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(ColorTurboGear.colorPicker(.maroon))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal, 40)
            .frame(maxWidth: bigSize ? 400 : 336)
        }
    }
}

#Preview {
    DeleteConfirmationAlertView { _ in }
}
