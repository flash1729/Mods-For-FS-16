//
//  BlueBackgroundWithBorder.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct BlueBackgroundWithBorder: View {
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var cornerRadiusCustom: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadiusCustom)
            .fill(ColorTurboGear.colorPicker(.cyan))
            .overlay {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadiusCustom)
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
                    
                    RoundedRectangle(cornerRadius: cornerRadiusCustom)
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
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCustom))
    }
}

#Preview {
    BlueBackgroundWithBorder(cornerRadiusCustom: 16)
}
