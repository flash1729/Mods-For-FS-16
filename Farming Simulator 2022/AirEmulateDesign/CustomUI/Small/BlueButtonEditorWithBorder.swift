//
//  BlueButtonEditorWithBorder.swift
//  Farming Simulator 2022
//
//  Created by Sim on 01/10/24.
//

import SwiftUI

struct BlueButtonEditorWithBorder: View {
    @State var blueButtonTap: () -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @Binding var titleButton: String
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
                        
                        HStack {
                            Image(IconTurboGear.TopNavIconTurbo.topNamBackChevron)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .rotationEffect(.degrees(-90))
                                .opacity(0.0)
                            Text(titleButton)
                                .font(FontTurboGear.montserratStyle(size: bigSize ? 30 : 18, type: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                            Image(IconTurboGear.TopNavIconTurbo.topNamBackChevron)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                                .rotationEffect(.degrees(-90))
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: bigSize ? 30 : 16))
        }
        .frame(maxWidth: bigSize ? 627 : (infinityWidth ? .infinity : 335))
    }
}

#Preview {
    BlueButtonEditorWithBorder(blueButtonTap: {}, titleButton: .constant("Ok"))
}
