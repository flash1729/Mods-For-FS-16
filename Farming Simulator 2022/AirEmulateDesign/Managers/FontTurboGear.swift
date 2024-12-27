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
                return Font.custom("Gilroy-Black", size: size)
            case .semibold:
                return Font.custom("Gilroy-SemiBold", size: size)
            case .medium:
                return Font.custom("Gilroy-Medium", size: size)
            }
        }
}
