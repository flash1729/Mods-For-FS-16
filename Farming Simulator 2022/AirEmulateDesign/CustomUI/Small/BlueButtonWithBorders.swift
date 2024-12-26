//
//  BlueButtonWithBorders.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct BlueButtonWithBorders: View {
    @State var blueButtonTap: () -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var titleButton: String
    @State var infinityWidth: Bool = false
    var body: some View {
        Button {
            blueButtonTap()
        } label: {
            RoundedRectangle(cornerRadius: bigSize ? 30 : 16)
                .fill(ColorTurboGear.colorPicker(.cyan))
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
                            .font(FontTurboGear.montserratStyle(size: bigSize ? 30 : 18, type: .semibold))
                            .foregroundColor(Color.white)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: bigSize ? 30 : 16))
        }
        .frame(maxWidth: bigSize ? 627 : (infinityWidth ? .infinity : 335))
    }
}

#Preview {
    BlueButtonWithBorders(blueButtonTap: {}, titleButton: "Ok")
}
