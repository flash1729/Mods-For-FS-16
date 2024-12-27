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
    
    // Constants updated to match design specifications
    private let capsuleHeight: CGFloat = 53 // Updated to match design spec
    private let capsuleWidth: CGFloat = 34  // Updated to match design spec
    private let capsuleRadius: CGFloat = 24 // Updated to match design spec
    private let containerPadding: CGFloat = 24
    private let numberOfCapsules = 8
    private let unfilliedOpacity: Double = 0.3 // Updated opacity for unfilled capsules
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Loading text showing current progress
            Text("Loading, \(progressTimer)%")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Progress capsules
            HStack(spacing: 8) {
                ForEach(0..<numberOfCapsules, id: \.self) { index in
                    Capsule()
                        .fill(ColorTurboGear.colorPicker(.darkGreen))
                        .opacity(shouldFillCapsule(at: index) ? 1.0 : unfilliedOpacity)
                        .frame(width: capsuleWidth, height: capsuleHeight)
                }
            }
        }
        .padding(containerPadding)
        .frame(maxWidth: bigSize ? 600 : 343)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: capsuleRadius))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .onChange(of: progressTimer) { newValue in
            let progress = Double(progressTimer)
            let filledCapsules = Int((progress / 100.0) * Double(numberOfCapsules))
            countOfRectangle = min(filledCapsules, numberOfCapsules)
        }
    }
    
    private func shouldFillCapsule(at index: Int) -> Bool {
        return index < countOfRectangle
    }
}
// Preview provider for development and testing
struct LoadingLoaderCustomElement_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            LoadingLoaderCustomElement(progressTimer: .constant(50))
        }
    }
}
