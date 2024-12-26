//
//  LostConnectElement.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct LostConnectElement: View {
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var tapOkButton: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            VStack(spacing: bigSize ? 50 : 28) {
                Image(IconTurboGear.NoInternetIconForceNitro)
                    .resizable()
                    .scaledToFit()
                    .frame(height: bigSize ? 100 : 56)
                Text("No internet")
                    .font(FontTurboGear.montserratStyle(size: bigSize ? 35 : 20, type: .bold))
                Button {
                    tapOkButton()
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ColorTurboGear.colorPicker(.cyan))
                        .frame(height: bigSize ? 100 : 56)
                        .overlay {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
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
                                RoundedRectangle(cornerRadius: 16)
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
                                
                                Text("Ok".uppercased())
                                    .font(FontTurboGear.montserratStyle(size: bigSize ? 30 : 18, type: .semibold))
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .frame(maxWidth: bigSize ? 300 : 169)
            }
            .padding(.vertical, bigSize ? 56 : 32)
            .frame(maxWidth: bigSize ? 530 : 300)
            .foregroundColor(Color.white)
            .background(ColorTurboGear.colorPicker(.gray))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    LostConnectElement(tapOkButton: {})
}
