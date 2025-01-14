//
//  LoadingLoaderCustomElement.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

//struct LoadingLoaderCustomElement: View {
//    @Binding var progressTimer: Int
//    @State var countOfRectangle: Int = 0
//    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
//    
//    // Constants updated to match design specifications
//    private let capsuleHeight: CGFloat = 53 // Updated to match design spec
//    private let capsuleWidth: CGFloat = 34  // Updated to match design spec
//    private let capsuleRadius: CGFloat = 24 // Updated to match design spec
//    private let containerPadding: CGFloat = 24
//    private let numberOfCapsules = 8
//    private let unfilliedOpacity: Double = 0.3 // Updated opacity for unfilled capsules
//    
//    var body: some View {
//        ZStack{
//            Color.white.ignoresSafeArea()
//            
//            VStack(alignment: .leading, spacing: 12) {
//                // Loading text showing current progress
//                Text("Loading, \(progressTimer)%")
//                    .font(.system(size: 16, weight: .medium))
//                    .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
//                    .frame(maxWidth: .infinity, alignment: .center)
//                
//                // Progress capsules
//                HStack(spacing: 8) {
//                    ForEach(0..<numberOfCapsules, id: \.self) { index in
//                        Capsule()
//                            .fill(ColorTurboGear.colorPicker(.darkGreen))
//                            .opacity(shouldFillCapsule(at: index) ? 1.0 : unfilliedOpacity)
//                            .frame(width: capsuleWidth, height: capsuleHeight)
//                    }
//                }
//            }
//            .padding(containerPadding)
//            .frame(maxWidth: bigSize ? 600 : 343)
//            .background(Color.white)
//            .clipShape(RoundedRectangle(cornerRadius: capsuleRadius))
//            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
//            .onChange(of: progressTimer) { newValue in
//                let progress = Double(progressTimer)
//                let filledCapsules = Int((progress / 100.0) * Double(numberOfCapsules))
//                countOfRectangle = min(filledCapsules, numberOfCapsules)
//            }
//        }
//    }
//    
//    private func shouldFillCapsule(at index: Int) -> Bool {
//        return index < countOfRectangle
//    }
//}
//// Preview provider for development and testing
//struct LoadingLoaderCustomElement_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
//            LoadingLoaderCustomElement(progressTimer: .constant(50))
//        }
//    }
//}

struct LoadingLoaderCustomElement: View {
    @Binding var progressTimer: Int
    @State var countOfRectangle: Int = 0
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    // Constants updated for iPad and iPhone
    private var capsuleHeight: CGFloat { bigSize ? 70 : 53 }
    private var capsuleWidth: CGFloat { bigSize ? 45 : 34 }
    private var capsuleRadius: CGFloat { bigSize ? 32 : 24 }
    private var containerPadding: CGFloat { bigSize ? 32 : 24 }
    private var numberOfCapsules: Int { bigSize ? 14 : 8 }
    private var containerWidth: CGFloat { bigSize ? 700 : 343 }
    private var fontSize: CGFloat { bigSize ? 44 : 16 }
    private let unfilliedOpacity: Double = 0.3
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: bigSize ? 24 : 12) {
                // Loading text showing current progress
                Text("Loading, \(progressTimer)%")
                    .font(FontTurboGear.gilroyStyle(
                        size: fontSize,
                        type: .medium
                    ))
                    .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Progress capsules
                HStack(spacing: bigSize ? 12 : 8) {
                    ForEach(0..<numberOfCapsules, id: \.self) { index in
                        Capsule()
                            .fill(ColorTurboGear.colorPicker(.darkGreen))
                            .opacity(shouldFillCapsule(at: index) ? 1.0 : unfilliedOpacity)
                            .frame(width: capsuleWidth, height: capsuleHeight)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(containerPadding)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: capsuleRadius))
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onChange(of: progressTimer) { newValue in
                let progress = Double(progressTimer)
                let filledCapsules = Int((progress / 100.0) * Double(numberOfCapsules))
                countOfRectangle = min(filledCapsules, numberOfCapsules)
            }
        }
    }
    
    private func shouldFillCapsule(at index: Int) -> Bool {
        return index < countOfRectangle
    }
}

// Preview provider showing both iPhone and iPad versions
struct LoadingLoaderCustomElement_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // iPhone preview
            LoadingLoaderCustomElement(progressTimer: .constant(50))
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
                .previewDisplayName("iPhone")
            
            // iPad preview
            LoadingLoaderCustomElement(progressTimer: .constant(50))
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
                .previewDisplayName("iPad")
        }
    }
}
