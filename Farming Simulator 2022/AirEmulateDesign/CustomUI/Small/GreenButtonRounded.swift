//
//  BlueButtonWithBorders.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct GreenButtonRounded: View {
    @State var blueButtonTap: () -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var titleButton: String
    @State var infinityWidth: Bool = false
    var body: some View {
        Button {
            blueButtonTap()
        } label: {
            RoundedRectangle(cornerRadius: bigSize ? 30 : 16)
                .fill(ColorTurboGear.colorPicker(.green))
                .frame(height: bigSize ? 100 : 56)
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: bigSize ? 30 : 16)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0),
                                        Color.white.opacity(0)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: bigSize ? 6 : 3
                            )
                        
                        RoundedRectangle(cornerRadius: bigSize ? 30 : 16)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.3),
                                        Color.black.opacity(0),
                                        Color.black.opacity(0)
                                    ]),
                                    startPoint: .trailing,
                                    endPoint: .leading
                                ),
                                lineWidth: bigSize ? 6 : 3
                            )
                        
                        Text(titleButton)
                            .font(FontTurboGear.gilroyStyle(size: bigSize ? 30 : 18, type: .semibold))
                            .foregroundColor(Color.white)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: bigSize ? 30 : 16))
        }
        .frame(maxWidth: bigSize ? 627 : (infinityWidth ? .infinity : 335))
    }
}



struct GreenButtonWithBorders: View {
    // Required properties
    let title: String
    let action: () -> Void
    
    // Optional properties with defaults
    var disabled: Bool = false
    var showIcon: Bool = true
    
    // Device type check for responsive sizing
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    // Constants from design specs
    private let buttonHeight: CGFloat = 37
    private let cornerRadius: CGFloat = 8
    private let horizontalPadding: CGFloat = 24
    private let verticalPadding: CGFloat = 8
    private let borderWidth: CGFloat = 1
    private let spacing: CGFloat = 10
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: spacing) {
                Text(title)
                    .font(FontTurboGear.gilroyStyle(
                        size: bigSize ? 22 : 16,
                        type: .semibold
                    ))
                    .foregroundColor(.white)
            }
            .frame(height: buttonHeight)
            .frame(maxWidth: .infinity)
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
        .disabled(disabled)
        .opacity(disabled ? 0.5 : 1.0)
    }
}

// Preview for development
struct GreenButtonWithBorders_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorTurboGear.colorPicker(.green)
            VStack(spacing: 20) {
                GreenButtonWithBorders(
                    title: "Generate new +",
                    action: {}
                )
            }
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
