//
//  SkinsModel.swift
//  Farming Simulator 2022
//
//  Created by Sim on 29/09/24.
//

import Foundation
struct BeforeSkinsArray: Codable {
    let vmq9: SkinsArray
    
    enum CodingKeys: String, CodingKey {
        case vmq9 = "8swwa2"
    }
}

struct SkinsArray: Codable {
    let o2F0T7: [String: SkinsPattern]

    enum CodingKeys: String, CodingKey {
        case o2F0T7 = "r-xx3x"
    }
}

struct SkinsPattern: Codable, Equatable {
    
    let id: String
    let image: String
    let title: String
    let description: String
    let file: String
    var isFavorited: Bool?
    var imageData: Data?
    var top: Bool?
    var new: Bool?
    
    enum MyCodingKeysSkins: String, CodingKey {
        case id
        case image = "mzgz"
        case title = "80s4dex5v"
        case description = "j2z6p1fpn7"
        case file = "fw_19n"
        case isFavorited
        case imageData
        case top = "isTop"
        case new = "isNew"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyCodingKeysSkins.self)
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
    
    init(from coreDataObject: Skins) {
        self.id = coreDataObject.id ?? ""
        self.title = coreDataObject.title ?? ""
        self.description = coreDataObject.skinsDescription ?? ""
        self.image = coreDataObject.image ?? ""
        self.file = coreDataObject.file ?? ""
        self.isFavorited = coreDataObject.isFavorited
        self.imageData = coreDataObject.imageData
        self.top = coreDataObject.top
        self.new = coreDataObject.new
        
    }
}
