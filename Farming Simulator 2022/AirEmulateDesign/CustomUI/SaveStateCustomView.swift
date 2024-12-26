//
//  SaveStateIphone.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct SaveStateCustomView: View {
    @Binding var saveState: IconTurboGear.SaveStateIconTurbo
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(ColorTurboGear.colorPicker(.darkGray))
            .frame(height: 90)
            .overlay {
                HStack(spacing: 16) {
                    Image(saveState.rawValue)
                        .resizable()
                        .scaledToFit()
                    Text(saveState.sendTitleOfIcon())
                        .font(FontTurboGear.montserratStyle(size: bigSize ? 32 : 16, type: .medium))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .padding(24)
            }
    }
}

#Preview {
    SaveStateCustomView(saveState: .constant(.saveFailedIconElement))
}
