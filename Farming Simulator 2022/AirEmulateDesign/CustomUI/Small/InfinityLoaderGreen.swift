//
//  InfinityLoaderCyan.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//  Redesigned By Adi

import SwiftUI

struct InfinityLoaderGreen: View {
    @State private var rotation = 0.0
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State private var stopTimer: Bool = false
    @State private var progressLoader: Int = 0
    
    var body: some View {
        Circle()
            .fill(Color.clear)
            .overlay(
                Image("rotator")
                    .resizable()
                    .scaledToFit()
//                    .foregroundColor(ColorTurboGear.colorPicker(.green))
                    .rotationEffect(.degrees(Double(progressLoader * 45)))
            )
            .frame(width: bigSize ? 48 : 32, height: bigSize ? 48 : 32)
            .onAppear(){
                infinityLoading()
            }
            .onDisappear {
                stopTimer = true
            }
    }

    private func infinityLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.075, repeats: true) { time in
            if stopTimer {
                self.progressLoader = 0
                time.invalidate()
            } else {
                if self.progressLoader < 128 {
                    self.progressLoader += 1
                } else {
                    self.progressLoader = 0
                }
            }
        }
    }
}

#Preview {
    InfinityLoaderGreen()
}
