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
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: bigSize ? 24 : 16) {
                Text("Internet connection error")
                    .font(FontTurboGear.gilroyStyle(size: bigSize ? 24 : 16, type: .bold))
                    .foregroundColor(ColorTurboGear.colorPicker(.green))
                
                GreenButtonRounded(
                    blueButtonTap: tapOkButton,
                    titleButton: "OK",
                    infinityWidth: false
                )
            }
            .padding(.vertical, bigSize ? 32 : 24)
            .padding(.horizontal, bigSize ? 40 : 32)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    LostConnectElement(tapOkButton: {})
}
