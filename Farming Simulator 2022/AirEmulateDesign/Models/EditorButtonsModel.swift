//
//  EditorButtonsModel.swift
//  Farming Simulator 2022
//
//  Created by Sim on 01/10/24.
//

import Foundation

enum EditorTypePartOfBody: Int16, CaseIterable, Identifiable {
    case body //if change position thats change in all action buttons page too
    case top
    case accessories
    case trousers
    case shoes
    case hair
    var id: EditorTypePartOfBody { self }
    
    func stringValue() -> String {
        switch self {
        case .body: return "Gender"
        case .top: return "Top"
        case .accessories: return "Accessories"
        case .trousers: return "Bottom"
        case .shoes: return "Shoes"
        case .hair: return "Hair"
        }
    }
}

