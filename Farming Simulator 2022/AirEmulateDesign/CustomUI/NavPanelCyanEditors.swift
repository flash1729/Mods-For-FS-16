//
//  NavPanelCyanEditors.swift
//  Farming Simulator 2022
//
//  Created by Sim on 30/09/24.
//

import SwiftUI

struct NavPanelCyanEditors: View {
    @Environment(\.dismiss) var dismiss
    @State var titleName: String
    @Binding var rightbuttonIconType: IconTurboGear.TopNavIconTurbo
    @State var leftbuttonIconType: IconTurboGear.TopNavIconTurbo = .windowIcon
    @State var rigthButtonTapped: () -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var updateId: UUID = .init()
    var body: some View {
        VStack{
            HStack {
                Button {
                    dismiss()
                } label: {
                    NavButtonMiniIcon(typeOfImage: leftbuttonIconType)
                }
                Text(titleName)
                    .font(FontTurboGear.montserratStyle(size: 24, type: .bold))
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Button {
                    withAnimation {
                        rigthButtonTapped()
                    }
                } label: {
                    NavButtonMiniIcon(typeOfImage: rightbuttonIconType)
                        .id(updateId)
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
        .onChange(of: rightbuttonIconType) { newValue in
            updateId = UUID()
        }
    }
}

#Preview {
    NavPanelCyanEditors(titleName: "", rightbuttonIconType: .constant(.windowIcon), rigthButtonTapped: {})
}
