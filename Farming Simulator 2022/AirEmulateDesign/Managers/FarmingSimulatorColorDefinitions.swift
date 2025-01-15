//
//  ColorTurboGear.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import Foundation
import SwiftUI

enum ColorTurboGear {
    enum TypeOfColor {
        // New colors
        case grey
        case darkGreen
        case green
        case maroon
        
        // Old colors - marked for replacement
        @available(*, deprecated, message: "Use new design system colors instead")
        case cyan
        @available(*, deprecated, message: "Use new design system colors instead")
        case gray
        @available(*, deprecated, message: "Use new design system colors instead")
        case darkGray
        @available(*, deprecated, message: "Use new design system colors instead")
        case dirtYellow
    }
    
    static func colorPicker(_ type: TypeOfColor) -> Color {
        switch type {
        // New colors
        case .grey:
            return Color(red: 227/255, green: 226/255, blue: 226/255) // #E3E2E2
        case .darkGreen:
            return Color(red: 19/255, green: 61/255, blue: 38/255) // #133D26
        case .green:
            return Color(red: 20/255, green: 87/255, blue: 56/255) // #145738
        case .maroon:
            return Color(red: 99/255, green: 19/255, blue: 12/255) // #63130C
            
        // Old colors
        case .cyan:
            return Color(red: 0 / 255, green: 194 / 255, blue: 208 / 255)
        case .gray:
            return Color(red: 118 / 255, green: 130 / 255, blue: 117 / 255)
        case .darkGray:
            return Color(red: 49 / 255, green: 55 / 255, blue: 61 / 255)
        case .dirtYellow:
            return Color(red: 118 / 255, green: 130 / 255, blue: 117 / 255)
        }
    }
}

//enum ColorTurboGear {
//    enum TypeOfColor {
//        case grey
//        case darkGreen
//        case green
//        case maroon
//    }
//    
//    static func colorPicker(_ type: TypeOfColor) -> Color {
//        switch type {
//        case .grey:
//            return Color(red: 227/255, green: 226/255, blue: 226/255) // #E3E2E2
//        case .darkGreen:
//            return Color(red: 19/255, green: 61/255, blue: 38/255) // #133D26
//        case .green:
//            return Color(red: 20/255, green: 87/255, blue: 56/255) // #145738
//        case .maroon:
//            return Color(red: 99/255, green: 19/255, blue: 12/255) // #63130C
//        }
//    }
//}
