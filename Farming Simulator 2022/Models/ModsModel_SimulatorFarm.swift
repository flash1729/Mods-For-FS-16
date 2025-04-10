//
//  ModsModel.swift
//  Farming Simulator 2022
//
//  Created by Systems
//

import Foundation

struct ModCollection: Codable {
    let modsData: ModsData

    enum CodingKeys: String, CodingKey {
        case modsData = "90kx_cbr"
    }
}

// This intermediate structure represents the "p_uf" level
struct ModsData: Codable {
    let mods: [String: ModPattern]

    enum CodingKeys: String, CodingKey {
        case mods = "p_uf"
    }
}

struct ModPattern: Codable, Equatable {
    let id: String
    let image: String
    let title: String
    let description: String
    let file: String
    var isFavorited: Bool?
    var imageData: Data?
    var top: Bool?
    var new: Bool?
    
    enum MyCodingKeysDads: String, CodingKey {
        case id
        case image = "5cnyenj4w"
        case title = "qdtr354t"
        case description = "73iif2v_"
        case file = "q0gm"
        case isFavorited
        case imageData
        case top = "isTop"
        case new = "lastAdded"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyCodingKeysDads.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        image = try container.decode(String.self, forKey: .image)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        file = try container.decode(String.self, forKey: .file)
        top = try container.decodeIfPresent(Bool.self, forKey: .top)
        new = try container.decodeIfPresent(Bool.self, forKey: .new)
    }

    init(id: String, title: String, description: String, image: String, isFavorited: Bool?, file: String, imageData: Data?, top: Bool?, new: Bool?) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.isFavorited = isFavorited
        self.file = file
        self.imageData = imageData
        self.top = top
        self.new = new
    }
    
    init(from coreDataObject: Mod) {
        self.id = coreDataObject.id ?? ""
        self.title = coreDataObject.title ?? ""
        self.description = coreDataObject.modDescriptions ?? ""
        self.image = coreDataObject.image ?? ""
        self.file = coreDataObject.file ?? ""
        self.isFavorited = coreDataObject.isFavorited
        self.imageData = coreDataObject.imageData
        self.top = coreDataObject.top
        self.new = coreDataObject.new
        
    }
}
