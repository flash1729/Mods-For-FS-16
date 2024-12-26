//
//  SandvichManModel.swift
//  Farming Simulator 2022
//
//  Created by Sim on 21/10/24.
//

import Foundation
import SwiftUI

enum GenderTypeModel: Int16, CaseIterable, Identifiable {
    case man
    case woman
    var id: GenderTypeModel { self }
}

struct SandvichItemType {
    var image: UIImage?
    var imageName: String?
    var zindex: Int16?
    
    mutating func nilItems() {
        self.image = nil
        self.imageName = nil
        self.zindex = nil
    }
    
    mutating func updateFromCoreData(_ name: String){
        self.imageName = name
    }
}

struct SandvichPeople {
    var top: SandvichItemType?
    var body: SandvichItemType?
    var accessories: SandvichItemType?
    var bottom: SandvichItemType?
    var shoes: SandvichItemType?
    var hair: SandvichItemType?
    
    mutating func sendAllImages() -> [UIImage] {
        let tempArray: [SandvichItemType?] = [top, body, accessories, shoes, bottom, hair]
        var tempImageArray: [UIImage] = []
        let sortedArray = tempArray.sorted(by: {$0?.zindex ?? 0 < $1?.zindex ?? 1 })
        
        for item in sortedArray {
            if let image = item?.image {
                tempImageArray.append(image)
            }
        }
        return tempImageArray
    }
    
    mutating func allNil() {
        top?.nilItems()
        body?.nilItems()
        accessories?.nilItems()
        bottom?.nilItems()
        shoes?.nilItems()
        hair?.nilItems()
    }
    
    mutating func setNameImages(coreItem: BodyEditor) {
        body?.imageName = coreItem.body ?? ""
        body?.zindex = coreItem.bodyZ
        
        accessories?.imageName = coreItem.accessories ?? ""
        accessories?.zindex = coreItem.accessoriesZ
        
        bottom?.imageName = coreItem.bottom ?? ""
        bottom?.zindex = coreItem.bottomZ
        
        shoes?.imageName = coreItem.shoes ?? ""
        shoes?.zindex = coreItem.shoesZ
        
        hair?.imageName = coreItem.hair ?? ""
        hair?.zindex = coreItem.hairZ
    }
}
