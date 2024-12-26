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
        case cyan
        case gray
        case darkGray
        case dirtYellow
    }
    
    static func colorPicker(_ type: TypeOfColor) -> Color {
        switch type {
        case .cyan:
            return Color(red: 0 / 255, green: 194 / 255, blue: 208 / 255) //00C2D0
        case .gray:
            return Color(red: 118 / 255, green: 130 / 255, blue: 117 / 255) //768275
        case .darkGray:
            return Color(red: 49 / 255, green: 55 / 255, blue: 61 / 255) //31373D
        case .dirtYellow:
            return Color(red: 118 / 255, green: 130 / 255, blue: 117 / 255) //768275
        }
    }
}
