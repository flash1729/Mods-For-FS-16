//
//  SaveWaitStateIphone.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct SaveWaitStateIphone: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.05)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 32)
                .fill(ColorTurboGear.colorPicker(.darkGray))
                .frame(height: 220)
                .frame(maxWidth: 330)
                .overlay(content: {
                    waitCustomView
                })
                .padding(48)
            
        }
    }
    
    private var waitCustomView: some View {
        VStack(spacing: 25) {
            InfinityLoaderCyan()
                .frame(height: 55)
            Text("Please wait...")
                .font(FontTurboGear.montserratStyle(size: 24, type: .medium))
                .foregroundColor(Color.white)
        }
    }
}

#Preview {
    SaveWaitStateIphone()
}
