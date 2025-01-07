//
//  EditorViewModel.swift
//  Farming Simulator 2022
//
//  Created by Sim on 14/10/24.
//

import Foundation
import SwiftUI
import Photos
import CoreData

class EditorViewModel: ObservableObject {
    @Published var sandvichPeople: SandvichPeople = .init()
    @Published var tempManPeople: SandvichPeople? = .init()
    @Published var tempWomanPeople: SandvichPeople? = .init()
    @Published var fullImagePeopleToSave: UIImage?
    @Published var smallImagePeopleToSave: UIImage?
    @Published var updateData: Bool = false
    @Published var randomItem: SandvichPeople = .init()
    @Published var editNotSavedItem: Bool = false
    @Published var updateDataSecond: Bool = false
    @Published var changeGenderInButton: Bool = false
    
    func setImageToSandvich(type: EditorTypePartOfBody?, removeImage: Bool = false, choosedPart: String, choosedPartModel: EditorTypePartOfBody?, genderType: GenderTypeModel, allData: FetchedResults<BodyElement>) {
        switch type {
        case .accessories:
            if removeImage {
                sandvichPeople.accessories?.nilItems()
            } else if let itemToPeople = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).filter({$0.previewImageString == choosedPart}).first {
                let tempItem = SandvichItemType(image: UIImage(data: itemToPeople.editroImage ?? Data()), imageName: itemToPeople.previewImageString, zindex: Int16(itemToPeople.zIndex ?? "2") ?? 2)
                sandvichPeople.accessories = tempItem
            }
        case .trousers:
            if removeImage {
                sandvichPeople.bottom?.nilItems()
            } else if let itemToPeople = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).filter({$0.previewImageString == choosedPart}).first {
                let tempItem = SandvichItemType(image: UIImage(data: itemToPeople.editroImage ?? Data()), imageName: itemToPeople.previewImageString, zindex: Int16(itemToPeople.zIndex ?? "4") ?? 4)
                sandvichPeople.bottom = tempItem
            }
        case .hair:
            if removeImage {
                sandvichPeople.hair?.nilItems()
            } else if let itemToPeople = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).filter({$0.previewImageString == choosedPart}).first {
                let tempItem = SandvichItemType(image: UIImage(data: itemToPeople.editroImage ?? Data()), imageName: itemToPeople.previewImageString, zindex: Int16(itemToPeople.zIndex ?? "1") ?? 1)
                sandvichPeople.hair = tempItem
            }
        case .shoes:
            if removeImage {
                sandvichPeople.shoes?.nilItems()
            } else if let itemToPeople = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).filter({$0.previewImageString == choosedPart}).first {
                let tempItem = SandvichItemType(image: UIImage(data: itemToPeople.editroImage ?? Data()), imageName: itemToPeople.previewImageString, zindex: Int16(itemToPeople.zIndex ?? "3") ?? 3)
                sandvichPeople.shoes = tempItem
            }
        case .top:
            if removeImage {
                sandvichPeople.top?.nilItems()
            } else if let itemToPeople = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).filter({$0.previewImageString == choosedPart}).first {
                let tempItem = SandvichItemType(image: UIImage(data: itemToPeople.editroImage ?? Data()), imageName: itemToPeople.previewImageString, zindex: Int16(itemToPeople.zIndex ?? "5") ?? 5)
                sandvichPeople.top = tempItem
            }
        case .body:
            if removeImage {
                sandvichPeople.body?.nilItems()
            } else if let itemToPeople = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).filter({$0.previewImageString == choosedPart}).first {
                let tempItem = SandvichItemType(image: UIImage(data: itemToPeople.editroImage ?? Data()), imageName: itemToPeople.previewImageString, zindex: Int16(itemToPeople.zIndex ?? "0") ?? 0)
                sandvichPeople.body = tempItem
            }
        case .none:
            if removeImage {
                sandvichPeople.body?.nilItems()
            } else if let itemToPeople = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).filter({$0.previewImageString == choosedPart}).first {
                let tempItem = SandvichItemType(image: UIImage(data: itemToPeople.editroImage ?? Data()), imageName: itemToPeople.previewImageString, zindex: Int16(itemToPeople.zIndex ?? "0") ?? 0)
                sandvichPeople.body = tempItem
            }
        }
    }
    
    func filterElements(type: EditorTypePartOfBody?, genderType: GenderTypeModel, allData: FetchedResults<BodyElement>) -> [BodyElement] {
        let genderFilter = allData.filter({$0.genderType == genderType.rawValue})
        return genderFilter.filter({$0.typeOfPart == EditorTypePartOfBody(rawValue: type?.rawValue ?? 0)?.rawValue })
    }
    
    func changeIndexInElementScroll(choosedPartModel: EditorTypePartOfBody?, genderType: GenderTypeModel, allData: FetchedResults<BodyElement>) -> Int {
        
        switch choosedPartModel {
        case .accessories:
            if sandvichPeople.accessories != nil {
                if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.accessories?.imageName}) {
                    return firstIndex
                }
            }
        case .trousers:
            if sandvichPeople.bottom != nil {
                if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.bottom?.imageName}) {
                    return firstIndex
                }
            }
        case .hair:
            if sandvichPeople.hair != nil {
                if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.hair?.imageName}) {
                    return firstIndex
                }
            }
        case .shoes:
            if sandvichPeople.shoes != nil {
                if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.shoes?.imageName}) {
                    return firstIndex
                }
            }
        case .top:
            if sandvichPeople.top != nil {
                if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.top?.imageName}) {
                    return firstIndex
                }
            }
        case .body:
            if sandvichPeople.body != nil {
                if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.body?.imageName}) {
                    return firstIndex
                }
            }
        case nil:
            if sandvichPeople.body != nil {
                if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.body?.imageName}) {
                    return firstIndex
                }
            }
        }
        return 0
    }
    
    func mergeImages(from images: [UIImage]) -> UIImage? {
        if images.isEmpty { return nil }
        guard let size = images.first?.size else { return nil }
        
        let halfX = size.width / 3
        let halfY = size.height / 3

        let renderer = UIGraphicsImageRenderer(size: size)

        let result = renderer.image { context in
            for image in images {
                image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            }
        }

        DispatchQueue.main.async {
            self.fullImagePeopleToSave = result
            self.smallImagePeopleToSave = self.downscaleImage(result, to: CGSize(width: halfX, height: halfY))
        }

        return result
    }
    
    func downscaleImage(_ image: UIImage, to targetSize: CGSize) -> UIImage? {
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { context in
                image.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        }
    
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .authorized, .limited:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    func setSandvichItem(type: EditorTypePartOfBody, filterData: [BodyElement], ifBody: Bool = false) -> SandvichItemType {
        let typeOfBody = filterData.filter({$0.typeOfPart == type.rawValue}).randomElement()
        let typeOfBodyImageName = typeOfBody?.previewImageString
        let typeOfBodyZ: Int16? = Int16(typeOfBody?.zIndex ?? "0") ?? 5
        var typeOfBodyImage: UIImage?
        if ifBody {
            typeOfBodyImage = UIImage(data: typeOfBody?.editroImage ?? Data())
        } else {
            typeOfBodyImage = self.randomBool() ? nil : UIImage(data: typeOfBody?.editroImage ?? Data())
        }
        var typeOfBodyElement: SandvichItemType = .init(image: typeOfBodyImage, imageName: typeOfBodyImageName, zindex: typeOfBodyZ)
        if typeOfBodyImage == nil && !ifBody {
            typeOfBodyElement.nilItems()
        }
        return typeOfBodyElement
    }
    
    func randomAvaterConfiguration(genderType: GenderTypeModel, allData: FetchedResults<BodyElement>) -> SandvichPeople {
        let tempElement: SandvichPeople
        let filterArray = allData.filter({$0.genderType == genderType.rawValue})
        
        let top = setSandvichItem(type: .top, filterData: filterArray)
        let body = setSandvichItem(type: .body, filterData: filterArray, ifBody: true)
        let trousers = setSandvichItem(type: .trousers, filterData: filterArray)
        let accessories = setSandvichItem(type: .accessories, filterData: filterArray)
        let shoes = setSandvichItem(type: .shoes, filterData: filterArray)
        let hair = setSandvichItem(type: .hair, filterData: filterArray)
        
        tempElement = SandvichPeople(top: top, body: body, accessories: accessories, bottom: trousers, shoes: shoes, hair: hair)
        
        let _ = self.mergeImages(from: self.randomItem.sendAllImages())
        self.updateDataSecond.toggle()
        return tempElement
    }
    
    private func randomBool() -> Bool {
        let boolState = Bool.random()
        return boolState
    }
    
    func saveItemToCoreData(item: SandvichPeople?, viewContext: NSManagedObjectContext, genderType: GenderTypeModel, randomType: Bool, saveComplete: @escaping (Bool) -> Void) {
        if let imageUI = fullImagePeopleToSave {
            let newItem = BodyEditor(context: viewContext)
            newItem.idPeople = UUID()
            newItem.body = item?.body?.imageName ?? ""
            newItem.bodyZ = Int16(item?.body?.zindex ?? 0)
            newItem.accessories = item?.accessories?.imageName ?? ""
            newItem.accessoriesZ = Int16(item?.accessories?.zindex ?? 0)
            newItem.bottom = item?.bottom?.imageName ?? ""
            newItem.bottomZ = Int16(item?.bottom?.zindex ?? 0)
            newItem.gender = genderType.rawValue
            newItem.hair = item?.hair?.imageName ?? ""
            newItem.hairZ = Int16(item?.hair?.zindex ?? 0)
            newItem.randomKey = randomType
            newItem.shoes = item?.shoes?.imageName ?? ""
            newItem.shoesZ = Int16(item?.shoes?.zindex ?? 0)
            newItem.top = item?.top?.imageName ?? ""
            newItem.topZ = Int16(item?.top?.zindex ?? 0)
            newItem.date = Date()
            newItem.fullImage = imageUI.pngData()
            if let smallImagePeopleToSave {
                newItem.smallPreviewImage = smallImagePeopleToSave.pngData()
            }
            try? viewContext.save()
            saveComplete(true)
        } else {
            saveComplete(false)
        }
    }
    
    func updateItemToCoreData(updateItem: BodyEditor, item: SandvichPeople?, viewContext: NSManagedObjectContext, genderType: GenderTypeModel, randomType: Bool, saveComplete: @escaping (Bool) -> Void) {
        if let imageUI = fullImagePeopleToSave {
            updateItem.body = item?.body?.imageName ?? ""
            updateItem.bodyZ = Int16(item?.body?.zindex ?? 0)
            updateItem.accessories = item?.accessories?.imageName ?? ""
            updateItem.accessoriesZ = Int16(item?.accessories?.zindex ?? 0)
            updateItem.bottom = item?.bottom?.imageName ?? ""
            updateItem.bottomZ = Int16(item?.bottom?.zindex ?? 0)
            updateItem.gender = genderType.rawValue
            updateItem.hair = item?.hair?.imageName ?? ""
            updateItem.hairZ = Int16(item?.hair?.zindex ?? 0)
            updateItem.randomKey = randomType
            updateItem.shoes = item?.shoes?.imageName ?? ""
            updateItem.shoesZ = Int16(item?.shoes?.zindex ?? 0)
            updateItem.top = item?.top?.imageName ?? ""
            updateItem.topZ = Int16(item?.top?.zindex ?? 0)
            updateItem.date = Date()
            updateItem.fullImage = imageUI.pngData()
            if let smallImagePeopleToSave {
                updateItem.smallPreviewImage = smallImagePeopleToSave.pngData()
            }
            try? viewContext.save()
            saveComplete(true)
        } else {
            saveComplete(false)
        }
    }
    
    func updateWithoutSaveItemTCoreData(updateItem: BodyEditor, item: SandvichPeople?, genderType: GenderTypeModel, randomType: Bool) {
        if let imageUI = fullImagePeopleToSave {
            updateItem.body = item?.body?.imageName ?? ""
            updateItem.bodyZ = Int16(item?.body?.zindex ?? 0)
            updateItem.accessories = item?.accessories?.imageName ?? ""
            updateItem.accessoriesZ = Int16(item?.accessories?.zindex ?? 0)
            updateItem.bottom = item?.bottom?.imageName ?? ""
            updateItem.bottomZ = Int16(item?.bottom?.zindex ?? 0)
            updateItem.gender = genderType.rawValue
            updateItem.hair = item?.hair?.imageName ?? ""
            updateItem.hairZ = Int16(item?.hair?.zindex ?? 0)
            updateItem.randomKey = randomType
            updateItem.shoes = item?.shoes?.imageName ?? ""
            updateItem.shoesZ = Int16(item?.shoes?.zindex ?? 0)
            updateItem.top = item?.top?.imageName ?? ""
            updateItem.topZ = Int16(item?.top?.zindex ?? 0)
            updateItem.date = Date()
            updateItem.fullImage = imageUI.pngData()
            if let smallImagePeopleToSave {
                updateItem.smallPreviewImage = smallImagePeopleToSave.pngData()
            }
        }
    }
    
    func clearCache() {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        if let files = try? FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil, options: []) {
            for file in files {
                try? FileManager.default.removeItem(at: file)
            }
        }
        print("Cache cleared")
    }
}

// Image cache for better performance
//class ImageCache {
//    static let shared = ImageCache()
//    private var cache = NSCache<NSString, UIImage>()
//    
//    func set(_ image: UIImage, key: String) {
//        cache.setObject(image, forKey: key as NSString)
//    }
//    
//    func get(key: String) -> UIImage? {
//        return cache.object(forKey: key as NSString)
//    }
//    
//    func clear() {
//        cache.removeAllObjects()
//    }
//}
//
//class EditorViewModel: ObservableObject {
//    // Existing published properties remain unchanged
//    @Published var sandvichPeople: SandvichPeople = .init()
//    @Published var tempManPeople: SandvichPeople? = .init()
//    @Published var tempWomanPeople: SandvichPeople? = .init()
//    @Published var fullImagePeopleToSave: UIImage?
//    @Published var smallImagePeopleToSave: UIImage?
//    @Published var updateData: Bool = false
//    @Published var randomItem: SandvichPeople = .init()
//    @Published var editNotSavedItem: Bool = false
//    @Published var updateDataSecond: Bool = false
//    @Published var changeGenderInButton: Bool = false
//    
//    // Add queue for image processing
//    private let imageUpdateQueue = DispatchQueue(label: "com.app.editorImageUpdate", qos: .userInitiated)
//    
//    func setImageToSandvich(type: EditorTypePartOfBody?, removeImage: Bool = false, choosedPart: String, choosedPartModel: EditorTypePartOfBody?, genderType: GenderTypeModel, allData: FetchedResults<BodyElement>) {
//        switch type {
//        case .accessories, .trousers, .hair, .shoes, .top, .body, .none:
//            handlePartUpdate(type: type, removeImage: removeImage, choosedPart: choosedPart, choosedPartModel: choosedPartModel, genderType: genderType, allData: allData)
//        }
//    }
//    
//    private func handlePartUpdate(type: EditorTypePartOfBody?, removeImage: Bool, choosedPart: String, choosedPartModel: EditorTypePartOfBody?, genderType: GenderTypeModel, allData: FetchedResults<BodyElement>) {
//        imageUpdateQueue.async {
//            if removeImage {
//                DispatchQueue.main.async {
//                    switch type {
//                    case .accessories: self.sandvichPeople.accessories?.nilItems()
//                    case .trousers: self.sandvichPeople.bottom?.nilItems()
//                    case .hair: self.sandvichPeople.hair?.nilItems()
//                    case .shoes: self.sandvichPeople.shoes?.nilItems()
//                    case .top: self.sandvichPeople.top?.nilItems()
//                    case .body, .none: self.sandvichPeople.body?.nilItems()
//                    }
//                }
//                return
//            }
//            
//            guard let itemToPeople = self.filterElements(type: choosedPartModel, genderType: genderType, allData: allData)
//                .first(where: { $0.previewImageString == choosedPart }) else { return }
//            
//            // Create cache key for the image
//            let cacheKey = "\(choosedPart)_\(genderType.rawValue)"
//            
//            // Try to get image from cache first
//            if let cachedImage = ImageCache.shared.get(key: cacheKey) {
//                self.updateSandvichWithImage(type: type, image: cachedImage, imageName: itemToPeople.previewImageString, zIndex: itemToPeople.zIndex)
//                return
//            }
//            
//            // If not in cache, create new image
//            if let imageData = itemToPeople.editroImage,
//               let image = UIImage(data: imageData) {
//                // Cache the image
//                ImageCache.shared.set(image, key: cacheKey)
//                self.updateSandvichWithImage(type: type, image: image, imageName: itemToPeople.previewImageString, zIndex: itemToPeople.zIndex)
//            }
//        }
//    }
//    
//    private func updateSandvichWithImage(type: EditorTypePartOfBody?, image: UIImage, imageName: String?, zIndex: String?) {
//        DispatchQueue.main.async {
//            let tempItem = SandvichItemType(
//                image: image,
//                imageName: imageName,
//                zindex: Int16(zIndex ?? "0") ?? self.getDefaultZIndex(for: type)
//            )
//            
//            switch type {
//            case .accessories: self.sandvichPeople.accessories = tempItem
//            case .trousers: self.sandvichPeople.bottom = tempItem
//            case .hair: self.sandvichPeople.hair = tempItem
//            case .shoes: self.sandvichPeople.shoes = tempItem
//            case .top: self.sandvichPeople.top = tempItem
//            case .body, .none: self.sandvichPeople.body = tempItem
//            }
//        }
//    }
//    
//    private func getDefaultZIndex(for type: EditorTypePartOfBody?) -> Int16 {
//        switch type {
//        case .accessories: return 2
//        case .trousers: return 4
//        case .hair: return 1
//        case .shoes: return 3
//        case .top: return 5
//        case .body, .none: return 0
//        }
//    }
//    
//    func mergeImages(from images: [UIImage]) -> UIImage? {
//        guard !images.isEmpty else { return nil }
//        
//        // Create cache key from images
//        let cacheKey = images.map { $0.pngData()?.base64EncodedString() ?? "" }.joined()
//        
//        // Check cache first
//        if let cachedImage = ImageCache.shared.get(key: cacheKey) {
//            DispatchQueue.main.async {
//                self.fullImagePeopleToSave = cachedImage
//                self.smallImagePeopleToSave = self.downscaleImage(cachedImage,
//                    to: CGSize(width: cachedImage.size.width/3, height: cachedImage.size.height/3))
//            }
//            return cachedImage
//        }
//        
//        // If not in cache, create new merged image
//        let size = images.first?.size ?? .zero
//        let renderer = UIGraphicsImageRenderer(size: size)
//        
//        let result = renderer.image { context in
//            images.forEach { $0.draw(in: CGRect(origin: .zero, size: size)) }
//        }
//        
//        // Cache the result
//        ImageCache.shared.set(result, key: cacheKey)
//        
//        DispatchQueue.main.async {
//            self.fullImagePeopleToSave = result
//            self.smallImagePeopleToSave = self.downscaleImage(result,
//                to: CGSize(width: size.width/3, height: size.height/3))
//        }
//        
//        return result
//    }
//    
//    // Optimize CoreData operations
//    func saveItemToCoreData(item: SandvichPeople?, viewContext: NSManagedObjectContext, genderType: GenderTypeModel, randomType: Bool, saveComplete: @escaping (Bool) -> Void) {
//        imageUpdateQueue.async {
//            guard let imageUI = self.fullImagePeopleToSave else {
//                DispatchQueue.main.async { saveComplete(false) }
//                return
//            }
//            
//            let newItem = BodyEditor(context: viewContext)
//            self.updateBodyEditorProperties(newItem, with: item, genderType: genderType, randomType: randomType)
//            
//            do {
//                try viewContext.save()
//                DispatchQueue.main.async { saveComplete(true) }
//            } catch {
//                print("Error saving context: \(error)")
//                DispatchQueue.main.async { saveComplete(false) }
//            }
//        }
//    }
//    
//    private func updateBodyEditorProperties(_ editor: BodyEditor, with item: SandvichPeople?, genderType: GenderTypeModel, randomType: Bool) {
//        editor.idPeople = UUID()
//        editor.date = Date()
//        editor.gender = genderType.rawValue
//        editor.randomKey = randomType
//        
//        // Update only if values have changed
//        if editor.body != item?.body?.imageName {
//            editor.body = item?.body?.imageName ?? ""
//            editor.bodyZ = Int16(item?.body?.zindex ?? 0)
//        }
//        
//        if editor.accessories != item?.accessories?.imageName {
//            editor.accessories = item?.accessories?.imageName ?? ""
//            editor.accessoriesZ = Int16(item?.accessories?.zindex ?? 0)
//        }
//        
//        if editor.bottom != item?.bottom?.imageName {
//            editor.bottom = item?.bottom?.imageName ?? ""
//            editor.bottomZ = Int16(item?.bottom?.zindex ?? 0)
//        }
//        
//        if editor.hair != item?.hair?.imageName {
//            editor.hair = item?.hair?.imageName ?? ""
//            editor.hairZ = Int16(item?.hair?.zindex ?? 0)
//        }
//        
//        if editor.shoes != item?.shoes?.imageName {
//            editor.shoes = item?.shoes?.imageName ?? ""
//            editor.shoesZ = Int16(item?.shoes?.zindex ?? 0)
//        }
//        
//        if editor.top != item?.top?.imageName {
//            editor.top = item?.top?.imageName ?? ""
//            editor.topZ = Int16(item?.top?.zindex ?? 0)
//        }
//        
//        if let fullImage = fullImagePeopleToSave?.pngData(),
//           editor.fullImage != fullImage {
//            editor.fullImage = fullImage
//        }
//        
//        if let smallImage = smallImagePeopleToSave?.pngData(),
//           editor.smallPreviewImage != smallImage {
//            editor.smallPreviewImage = smallImage
//        }
//    }
//    
//    func filterElements(type: EditorTypePartOfBody?, genderType: GenderTypeModel, allData: FetchedResults<BodyElement>) -> [BodyElement] {
//            let genderFilter = allData.filter({$0.genderType == genderType.rawValue})
//            return genderFilter.filter({$0.typeOfPart == EditorTypePartOfBody(rawValue: type?.rawValue ?? 0)?.rawValue })
//        }
//    
//        func changeIndexInElementScroll(choosedPartModel: EditorTypePartOfBody?, genderType: GenderTypeModel, allData: FetchedResults<BodyElement>) -> Int {
//    
//            switch choosedPartModel {
//            case .accessories:
//                if sandvichPeople.accessories != nil {
//                    if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.accessories?.imageName}) {
//                        return firstIndex
//                    }
//                }
//            case .trousers:
//                if sandvichPeople.bottom != nil {
//                    if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.bottom?.imageName}) {
//                        return firstIndex
//                    }
//                }
//            case .hair:
//                if sandvichPeople.hair != nil {
//                    if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.hair?.imageName}) {
//                        return firstIndex
//                    }
//                }
//            case .shoes:
//                if sandvichPeople.shoes != nil {
//                    if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.shoes?.imageName}) {
//                        return firstIndex
//                    }
//                }
//            case .top:
//                if sandvichPeople.top != nil {
//                    if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.top?.imageName}) {
//                        return firstIndex
//                    }
//                }
//            case .body:
//                if sandvichPeople.body != nil {
//                    if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.body?.imageName}) {
//                        return firstIndex
//                    }
//                }
//            case nil:
//                if sandvichPeople.body != nil {
//                    if let firstIndex = filterElements(type: choosedPartModel, genderType: genderType, allData: allData).firstIndex(where: {$0.previewImageString == sandvichPeople.body?.imageName}) {
//                        return firstIndex
//                    }
//                }
//            }
//            return 0
//        }
//    
//        func downscaleImage(_ image: UIImage, to targetSize: CGSize) -> UIImage? {
//                let renderer = UIGraphicsImageRenderer(size: targetSize)
//                return renderer.image { context in
//                    image.draw(in: CGRect(origin: .zero, size: targetSize))
//                }
//            }
//    
//        func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
//            let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
//            switch status {
//            case .authorized, .limited:
//                completion(true)
//            case .denied, .restricted:
//                completion(false)
//            case .notDetermined:
//                PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
//                    DispatchQueue.main.async {
//                        if newStatus == .authorized || newStatus == .limited {
//                            completion(true)
//                        } else {
//                            completion(false)
//                        }
//                    }
//                }
//            @unknown default:
//                completion(false)
//            }
//        }
//    
//        func setSandvichItem(type: EditorTypePartOfBody, filterData: [BodyElement], ifBody: Bool = false) -> SandvichItemType {
//            let typeOfBody = filterData.filter({$0.typeOfPart == type.rawValue}).randomElement()
//            let typeOfBodyImageName = typeOfBody?.previewImageString
//            let typeOfBodyZ: Int16? = Int16(typeOfBody?.zIndex ?? "0") ?? 5
//            var typeOfBodyImage: UIImage?
//            if ifBody {
//                typeOfBodyImage = UIImage(data: typeOfBody?.editroImage ?? Data())
//            } else {
//                typeOfBodyImage = self.randomBool() ? nil : UIImage(data: typeOfBody?.editroImage ?? Data())
//            }
//            var typeOfBodyElement: SandvichItemType = .init(image: typeOfBodyImage, imageName: typeOfBodyImageName, zindex: typeOfBodyZ)
//            if typeOfBodyImage == nil && !ifBody {
//                typeOfBodyElement.nilItems()
//            }
//            return typeOfBodyElement
//        }
//    
//        func randomAvaterConfiguration(genderType: GenderTypeModel, allData: FetchedResults<BodyElement>) -> SandvichPeople {
//            let tempElement: SandvichPeople
//            let filterArray = allData.filter({$0.genderType == genderType.rawValue})
//    
//            let top = setSandvichItem(type: .top, filterData: filterArray)
//            let body = setSandvichItem(type: .body, filterData: filterArray, ifBody: true)
//            let trousers = setSandvichItem(type: .trousers, filterData: filterArray)
//            let accessories = setSandvichItem(type: .accessories, filterData: filterArray)
//            let shoes = setSandvichItem(type: .shoes, filterData: filterArray)
//            let hair = setSandvichItem(type: .hair, filterData: filterArray)
//    
//            tempElement = SandvichPeople(top: top, body: body, accessories: accessories, bottom: trousers, shoes: shoes, hair: hair)
//    
//            let _ = self.mergeImages(from: self.randomItem.sendAllImages())
//            self.updateDataSecond.toggle()
//            return tempElement
//        }
//    
//        private func randomBool() -> Bool {
//            let boolState = Bool.random()
//            return boolState
//        }
//    
//    func updateItemToCoreData(updateItem: BodyEditor, item: SandvichPeople?, viewContext: NSManagedObjectContext, genderType: GenderTypeModel, randomType: Bool, saveComplete: @escaping (Bool) -> Void) {
//           if let imageUI = fullImagePeopleToSave {
//               updateItem.body = item?.body?.imageName ?? ""
//               updateItem.bodyZ = Int16(item?.body?.zindex ?? 0)
//               updateItem.accessories = item?.accessories?.imageName ?? ""
//               updateItem.accessoriesZ = Int16(item?.accessories?.zindex ?? 0)
//               updateItem.bottom = item?.bottom?.imageName ?? ""
//               updateItem.bottomZ = Int16(item?.bottom?.zindex ?? 0)
//               updateItem.gender = genderType.rawValue
//               updateItem.hair = item?.hair?.imageName ?? ""
//               updateItem.hairZ = Int16(item?.hair?.zindex ?? 0)
//               updateItem.randomKey = randomType
//               updateItem.shoes = item?.shoes?.imageName ?? ""
//               updateItem.shoesZ = Int16(item?.shoes?.zindex ?? 0)
//               updateItem.top = item?.top?.imageName ?? ""
//               updateItem.topZ = Int16(item?.top?.zindex ?? 0)
//               updateItem.date = Date()
//               updateItem.fullImage = imageUI.pngData()
//               if let smallImagePeopleToSave {
//                   updateItem.smallPreviewImage = smallImagePeopleToSave.pngData()
//               }
//               try? viewContext.save()
//               saveComplete(true)
//           } else {
//               saveComplete(false)
//           }
//       }
//   
//       func updateWithoutSaveItemTCoreData(updateItem: BodyEditor, item: SandvichPeople?, genderType: GenderTypeModel, randomType: Bool) {
//           if let imageUI = fullImagePeopleToSave {
//               updateItem.body = item?.body?.imageName ?? ""
//               updateItem.bodyZ = Int16(item?.body?.zindex ?? 0)
//               updateItem.accessories = item?.accessories?.imageName ?? ""
//               updateItem.accessoriesZ = Int16(item?.accessories?.zindex ?? 0)
//               updateItem.bottom = item?.bottom?.imageName ?? ""
//               updateItem.bottomZ = Int16(item?.bottom?.zindex ?? 0)
//               updateItem.gender = genderType.rawValue
//               updateItem.hair = item?.hair?.imageName ?? ""
//               updateItem.hairZ = Int16(item?.hair?.zindex ?? 0)
//               updateItem.randomKey = randomType
//               updateItem.shoes = item?.shoes?.imageName ?? ""
//               updateItem.shoesZ = Int16(item?.shoes?.zindex ?? 0)
//               updateItem.top = item?.top?.imageName ?? ""
//               updateItem.topZ = Int16(item?.top?.zindex ?? 0)
//               updateItem.date = Date()
//               updateItem.fullImage = imageUI.pngData()
//               if let smallImagePeopleToSave {
//                   updateItem.smallPreviewImage = smallImagePeopleToSave.pngData()
//               }
//           }
//       }
//   
//       func clearCache() {
//           let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
//   
//           if let files = try? FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil, options: []) {
//               for file in files {
//                   try? FileManager.default.removeItem(at: file)
//               }
//           }
//           print("Cache cleared")
//       }
//}

