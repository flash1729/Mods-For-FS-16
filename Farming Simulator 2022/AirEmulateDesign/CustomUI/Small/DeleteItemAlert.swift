//
//  DeleteItemAlert.swift
//  Farming Simulator 2022
//
//  Created by Sim on 01/10/24.
//

import SwiftUI

struct DeleteItemAlert: View {
    @State var stateTapped: (Bool) -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    stateTapped(false)
                }
            VStack(spacing: 0) {
                Text("Are you sure?")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text("This action will remove your character")
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .padding(.vertical, bigSize ? 44 : 28)
                BlueButtonWithBorders(blueButtonTap: {
                    stateTapped(true)
                }, titleButton: "OK")
                .frame(maxWidth: bigSize ? 350 : 169)
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
    DeleteItemAlert(stateTapped: {_ in})
}
