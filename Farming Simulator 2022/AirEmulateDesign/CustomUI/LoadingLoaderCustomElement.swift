//
//  LoadingLoaderCustomElement.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct LoadingLoaderCustomElement: View {
    @Binding var progressTimer: Int
    @State var countOfRectangle: Int = 0
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        VStack {
            Text("Loading")
                .font(FontTurboGear.montserratStyle(size: bigSize ? 44 : 24, type: .bold))
                .foregroundColor(Color.white)
                .padding(.bottom, bigSize ? 45 : 24)
            HStack(spacing: bigSize ? 8 : 4) {
                ForEach(0..<13) { item in
                    rectangleElement
                        .opacity(item < countOfRectangle ? 1.0 : 0.0)
                }
            }
            .padding(bigSize ? 8 : 4)
            .frame(maxWidth: bigSize ? 600 : 324)
            .frame(height: bigSize ? 63 : 34)
            .background(ColorTurboGear.colorPicker(.gray))
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: bigSize ? 23 : 12)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0),
                                    Color.white.opacity(0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: bigSize ? 6 : 3
                        )
                    RoundedRectangle(cornerRadius: bigSize ? 23 : 12)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0),
                                    Color.white.opacity(0)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: bigSize ? 6 : 3
                        )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: bigSize ? 23 : 12))
        }
        .paddingFlyBullet()
        .onChange(of: progressTimer) { newValue in
            let tempCount = Double(progressTimer) / 7.5
            countOfRectangle = Int(tempCount)

        }
    }
    
    
    
    private var rectangleElement: some View {
        RoundedRectangle(cornerRadius: bigSize ? 12 : 6)
            .fill(ColorTurboGear.colorPicker(.cyan))
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: bigSize ? 12 : 6)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0)]),
                                startPoint: .trailing,
                                endPoint: .leading
                            ),
                            lineWidth: bigSize ? 6 : 3
                        )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: bigSize ? 12 : 6))
    }
}

#Preview {
    LoadingLoaderCustomElement(progressTimer: .constant(6))
}
