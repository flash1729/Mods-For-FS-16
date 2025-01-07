//
//  BlueButtonEditorWithBorder.swift
//  Farming Simulator 2022
//
//  Created by Sim on 01/10/24.
//

import SwiftUI

struct GreenButtonEditorWithBorder: View {
    let blueButtonTap: () -> Void
    @Binding var titleButton: String
    var infinityWidth: Bool = false
    
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var isExpanded: Bool = false

    private let cornerRadius: CGFloat = 8
    private let horizontalPadding: CGFloat = 24
    private let verticalPadding: CGFloat = 8
    private let borderWidth: CGFloat = 1
    private let iconSize: CGFloat = 25
    
    var body: some View {
        Button(action: blueButtonTap) {
            HStack(spacing: 16) {
                Text(titleButton)
                    .font(FontTurboGear.gilroyStyle(
                        size: bigSize ? 22 : 16,
                        type: .semibold
                    ))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                
                Image(IconTurboGear.TopNavIconTurbo.topNamBackChevron)
                    .resizable()
                    .scaledToFit()
                    .frame(height: iconSize)
                    .rotationEffect(.degrees(isExpanded ? 90 : -90)) // Modify this
                    .animation(.spring(), value: isExpanded)
            }
            .frame(height: bigSize ? 56 : 37)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                ColorTurboGear.colorPicker(.darkGreen)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        Color.white.opacity(0.16),
                        lineWidth: borderWidth
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .frame(maxWidth: bigSize ? 627 : (infinityWidth ? .infinity : 335))
    }
}

#Preview {
    GreenButtonEditorWithBorder(blueButtonTap: {}, titleButton: .constant("Ok"))
}
