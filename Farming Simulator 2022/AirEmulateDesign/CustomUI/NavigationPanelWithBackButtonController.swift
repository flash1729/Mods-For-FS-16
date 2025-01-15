//
//  NavPanelCyanWithoutFavButton.swift
//  Farming Simulator 2022
//
//  Created by Sim on 30/09/24.
//

import SwiftUI

struct NavigationPanelWithBackButtonController: View {
    @Environment(\.dismiss) var dismiss
    @State var titleName: String
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    // Constants for layout
    private let headerFontSize: CGFloat = 32
    private let standardPadding: CGFloat = 24
    
    var body: some View {
        VStack {
            HStack(spacing: standardPadding) {
                
                
                Text(titleName)
                    .font(FontTurboGear.gilroyStyle(size: bigSize ? 44 : headerFontSize, type: .bold))
                    .foregroundStyle(ColorTurboGear.colorPicker(.darkGreen))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    
                    Image(IconTurboGear.TopNavIconTurbo.menuHam)
                        .resizable()
                        .scaledToFit()
                        .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
        .paddingFlyBullet()
        .padding(.vertical, bigSize ? 24 : 20)
        .frame(maxWidth: .infinity)
        .frame(height: bigSize ? 137 : 128)
        .background(Color.white) // Ensure white background
    }
}

#Preview {
    NavigationPanelWithBackButtonController(titleName: "Nickname gen")
}
