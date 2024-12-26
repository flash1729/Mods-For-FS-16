//
//  MapsModel.swift
//  Farming Simulator 2022
//
//  Created by Systems
//

import Foundation

struct BeforeMapInfo: Codable {
    let ryiz0Alp: MapInfo

    enum CodingKeys: String, CodingKey {
        case ryiz0Alp = "ryiz0alp"
    }
}

struct MapInfo: Codable {
    let ovlcz2U1Cy: [String: MapPattern]

    enum CodingKeys: String, CodingKey {
        case ovlcz2U1Cy = "ovlcz2u1cy"
    }
}

struct MapPattern: Codable, Equatable {
    let id: String
    let image: String
    let title: String
    let description: String
    let file: String
    var isFavorited: Bool?
    var imageData: Data?
    var top: Bool?
    var new: Bool?
    
    enum MyCodingKeys: String, CodingKey {
        case id
        case image = "la-1kakhah"
        case title = "_kl-"
        case description = "a1nqe45e"
        case file = "l097"
        case isFavorited
        case imageData
        case top = "isPopular"
        case new = "lastAdded"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyCodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        image = try container.decode(String.self, forKey: .image)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        file = try container.decode(String.self, forKey: .file)
        top = try container.decodeIfPresent(Bool.self, forKey: .top)
        new = try container.decodeIfPresent(Bool.self, forKey: .new)
    }
    
    init(id: String, title: String, description: String, image: String, isFavorited: Bool?, file: String, imageData: Data?, top:Bool?, new: Bool?) {
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
    
    init(from coreDataObject: Map) {
        self.id = coreDataObject.id ?? ""
        self.title = coreDataObject.title ?? ""
        self.description = coreDataObject.mapDescriptions ?? ""
        self.image = coreDataObject.image ?? ""
        self.file = coreDataObject.file ?? ""
        self.isFavorited = coreDataObject.isFavorited
        self.imageData = coreDataObject.imageData
        self.top = coreDataObject.top
        self.new = coreDataObject.new
        
    }
}
