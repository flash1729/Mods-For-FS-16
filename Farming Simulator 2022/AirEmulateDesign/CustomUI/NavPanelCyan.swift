//
//  NavPanelCyan.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct NavPanelCyan: View {
    @Environment(\.dismiss) var dismiss
    @State var titleName: String
    @State var favoriteState: Bool
    @State var favoriteTapped: (Bool) -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        VStack{
            HStack {
                Button {
                    dismiss()
                } label: {
                    NavButtonMiniIcon(typeOfImage: IconTurboGear.TopNavIconTurbo.backChev)
                }
                Text(titleName)
                    .font(FontTurboGear.montserratStyle(size: 24, type: .bold))
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                if favoriteState {
                    Button {
                        withAnimation {
                            favoriteState = false
                            favoriteTapped(favoriteState)
                        }
                    } label: {
                        NavButtonMiniIcon(typeOfImage: IconTurboGear.TopNavIconTurbo.favActive)
                    }
                } else {
                    Button {
                        withAnimation {
                            favoriteState = true
                            favoriteTapped(favoriteState)
                        }
                    } label: {
                        NavButtonMiniIcon(typeOfImage: IconTurboGear.TopNavIconTurbo.favInactive)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .foregroundColor(.white)
        .paddingFlyBullet()
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .frame(height: bigSize ? 137 : 128)
        .background(
            ZStack {
                ColorTurboGear.colorPicker(.cyan)
                Color.clear
                    .contentShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
            }
        )
        .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
    }
}

#Preview {
    NavPanelCyan(titleName: "Name", favoriteState: true, favoriteTapped: {_ in})
}
