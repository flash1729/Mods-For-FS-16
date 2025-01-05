//
//  BodyEditorModel.swift
//  Farming Simulator 2022
//
//  Created by Sim on 02/10/24.
//

import Foundation

struct BeforoBodyEditorModel: Codable {
    let allObjects: BodyEditorModel

    enum CodingKeys: String, CodingKey {
        case allObjects = "kvbdel2p"
    }
}

struct BodyEditorModel: Codable {
    let top: [String: BodyEditorPattern]
    let pants: [String: BodyEditorPattern]
    let accessories: [String: BodyEditorPattern]
    let body: [String: BodyEditorPattern]
    let shoes: [String: BodyEditorPattern]
    let hair: [String: BodyEditorPattern]

    enum CodingKeys: String, CodingKey {
        case top = "Top"
        case pants = "Pants"
        case accessories = "Headdress"
        case body = "Body"
        case shoes = "Shoes"
        case hair = "Hair"
    }
}

struct BodyEditorPattern: Codable, Equatable {
    let id: String
    let smallImage: String
    let isTop: Bool
    let bigImage: String
    let position: String
    let isNew: Bool
    let genderType: GenderCoreData
    
    enum MyCodingKeysBodyEditor: String, CodingKey {
        case id
        case smallImage = "8mhw22_3"
        case isTop = "isTop"
        case bigImage = "sffmi93jiv"
        case position = "d18iebnm"
        case isNew = "lastAdded"
        case genderType = "3n9v1akn"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyCodingKeysBodyEditor.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        smallImage = try container.decode(String.self, forKey: .smallImage)
        isTop = try container.decode(Bool.self, forKey: .isTop)
        bigImage = try container.decode(String.self, forKey: .bigImage)
        position = try container.decode(String.self, forKey: .position)
        isNew = try container.decode(Bool.self, forKey: .isNew)
        genderType = try container.decode(GenderCoreData.self, forKey: .genderType)
    }
    
    init (id: String, smallImage: String, isTop: Bool, bigImage: String, position: String, isNew: Bool, genderType: GenderCoreData) {
        self.id = id
        self.smallImage = smallImage
        self.isTop = isTop
        self.bigImage = bigImage
        self.position = position
        self.isNew = isNew
        self.genderType = genderType
    }
}


enum GenderCoreData: String, Codable {
    case boy = "Boy"
    case girl = "Girl"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        // Handle case-insensitive matching
        switch stringValue.lowercased() {
        case "boy":
            self = .boy
        case "girl":
            self = .girl
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid gender value: \(stringValue). Expected 'Boy' or 'Girl'"
            )
        }
    }
}
