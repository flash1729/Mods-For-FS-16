//
//  FontTurboGear.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import Foundation
import SwiftUI

enum FontTurboGear {
    enum TypeOfFontTurboGear {
        case regular
        case bold
        case semibold
        case medium
    }
    
    @available(*, deprecated, message: "Use gilroyStyle instead")
    static func montserratStyle(size: CGFloat, type: TypeOfFontTurboGear) -> Font {
        return gilroyStyle(size: size, type: type)
    }
    
    static func gilroyStyle(size: CGFloat, type: TypeOfFontTurboGear) -> Font {
        switch type {
        case .regular:
            return Font.custom("Gilroy-Regular", size: size)
        case .bold:
            // Weight: 700
            return Font.custom("Gilroy-Bold", size: size)
                .weight(.bold) // This is weight 700
        case .semibold:
            return Font.custom("Gilroy-Semibold", size: size)
        case .medium:
            return Font.custom("Gilroy-Medium", size: size)
        }
    }
}
