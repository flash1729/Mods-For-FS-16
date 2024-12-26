//
//  NavPanelCyanWithoutFavButton.swift
//  Farming Simulator 2022
//
//  Created by Sim on 30/09/24.
//

import SwiftUI

struct NavPanelCyanWithoutFavButton: View {
    @Environment(\.dismiss) var dismiss
    @State var titleName: String
    @State var typeIcon: IconTurboGear.TopNavIconTurbo = .backChev
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        VStack{
            HStack {
                Button {
                    dismiss()
                } label: {
                    NavButtonMiniIcon(typeOfImage: typeIcon)
                }
                Text(titleName)
                    .font(FontTurboGear.montserratStyle(size: 24, type: .bold))
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                NavButtonMiniIcon(typeOfImage: typeIcon)
                    .opacity(0.0)
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
    NavPanelCyanWithoutFavButton(titleName: "")
}
