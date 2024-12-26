//
//  SaveEditorAlert.swift
//  Farming Simulator 2022
//
//  Created by Sim on 15/10/24.
//

import SwiftUI

struct SaveEditorAlert: View {
    @State var stateTapped: (Bool) -> Void
    @State var saveToHisory: Bool = false
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    stateTapped(false)
                }
            VStack(spacing: 0) {
                Text("Alert.")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text("This action will save your image to the \(saveToHisory ? "history" : "gallery").")
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .padding(.vertical, bigSize ? 44 : 28)
                HStack {
                    BlueButtonWithBorders(blueButtonTap: {
                        stateTapped(true)
                    }, titleButton: "OK")
                    .frame(maxWidth: bigSize ? 350 : 169)
                    BlueButtonWithBorders(blueButtonTap: {
                        stateTapped(false)
                    }, titleButton: "Cancel")
                    .frame(maxWidth: bigSize ? 350 : 169)
                }
            }
            .padding( bigSize ? 51 : 32)
            .font(FontTurboGear.montserratStyle(size: bigSize ? 32 : 20, type: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: 530)
            .background(ColorTurboGear.colorPicker(.dirtYellow))
            .clipShape(RoundedRectangle(cornerRadius: bigSize ? 26 : 16))
            .paddingFlyBullet()
                
                
        }
    }
}

#Preview {
    SaveEditorAlert(stateTapped: {_ in})
}
