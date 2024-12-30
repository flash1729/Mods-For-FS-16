//
//  NavPanelGreenWithBackButton.swift
//  Farming Simulator 2022
//
//  Created by Aditya Medhane on 30/12/24.
//
import SwiftUI

struct NavPanelGreenWithBackButton: View {
    @Environment(\.dismiss) var dismiss
    @State var titleName: String
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    // Constants for layout
    private let headerFontSize: CGFloat = 32
    private let standardPadding: CGFloat = 20
    
    var body: some View {
        VStack {
            HStack(spacing: standardPadding) {
                // Back Button
                Button {
                    dismiss()
                } label: {
                    Image("backButtonGreen")
                        .resizable()
                        .scaledToFit()
                        .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                }
                
                // Title
                Text(titleName)
                    .font(FontTurboGear.gilroyStyle(size: bigSize ? 34 : headerFontSize, type: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
        .paddingFlyBullet()
        .padding(.vertical, bigSize ? 24 : 20)
        .frame(maxWidth: .infinity)
        .frame(height: bigSize ? 137 : 128)
        .background(Color.white)
    }
}

#Preview {
    NavPanelGreenWithBackButton(titleName: "Item Details")
}
