//
//  Persistence.swift
//  Farming Simulator 2022
//
//  Created by Systems
//

import CoreData
import SwiftUI

struct PersistenceController {
    static var shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    private var mods = [Mod]()
    private var maps = [Map]()
    private var farms = [Farm]()
    private var skins = [Skins]()
    
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "mods_farming_simulator22")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            guard error == nil else { print("Error of loading: \(error!.localizedDescription)"); return }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        mods = arrayOf_SimulatorFarm (Mod.self, context: container.viewContext) ?? []
        maps = arrayOf_SimulatorFarm (Map.self, context: container.viewContext) ?? []
        farms = arrayOf_SimulatorFarm (Farm.self, context: container.viewContext) ?? []
        skins = arrayOf_SimulatorFarm (Skins.self, context: container.viewContext) ?? []
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access document directory")
        }
        let dbUrl = documentDirectory.appendingPathComponent("mods_farming_simulator22")
        print("Path to database: \(dbUrl.path)")
//        saveAll_SimulatorFarm()
    }
    
    
    
    private func arrayOf_SimulatorFarm<T: NSManagedObject>(_ entity: T.Type,
                                             predicate: NSPredicate? = nil,
                                             sortDescriptor: [NSSortDescriptor]? = nil,
                                             context: NSManagedObjectContext) -> [T]? {
        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        if predicate != nil {
            fetchRequest.predicate = predicate!
        }
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor!
        }
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let searchResult = try context.fetch(fetchRequest)
            if !searchResult.isEmpty {
                return searchResult
            } else {
                return nil
            }
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    mutating func deleteAll_FarmsAndModsAndMaps() {
        let allEntities = ["Farm", "Mod", "Map", "Skins"]
        for entity in allEntities {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try container.viewContext.execute(deleteRequest)
            } catch {
                // Error handler
            }
        }
        mods = arrayOf_SimulatorFarm(Mod.self, context: container.viewContext) ?? []
        maps = arrayOf_SimulatorFarm (Map.self, context: container.viewContext) ?? []
        farms = arrayOf_SimulatorFarm (Farm.self, context: container.viewContext) ?? []
        skins = arrayOf_SimulatorFarm (Skins.self, context: container.viewContext) ?? []
        
        saveAll_SimulatorFarm()
    }
    
    mutating func clearBodyPartCompletely() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "BodyElement")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container.viewContext.execute(batchDeleteRequest)
            container.viewContext.reset()
        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
    }
    
    mutating func clearSkinsCompletely() {
        for skin in skins {
            container.viewContext.delete(skin)
        }
        skins.removeAll()
        saveAll_SimulatorFarm()
    }
    
    mutating func clearModCompletely() {
        for mod in mods {
            container.viewContext.delete(mod)
        }
        mods.removeAll()
        saveAll_SimulatorFarm()
    }
    
    mutating func clearMapCompletely() {
        for map in maps {
            container.viewContext.delete(map)
        }
        maps.removeAll()
        saveAll_SimulatorFarm()
    }
    mutating func clearFarmCompletely() {
        for farm in farms {
            container.viewContext.delete(farm)
        }
        farms.removeAll()
        saveAll_SimulatorFarm()
    }
    
    mutating func appendSkin(from skinObject: SkinsPattern) {
        let skinEntity = Skins(context: container.viewContext)
        skinEntity.id = skinObject.id
        skinEntity.title = skinObject.title
        skinEntity.skinsDescription = skinObject.description
        skinEntity.image = skinObject.image
        skinEntity.file = skinObject.file
        skinEntity.isFavorited = skinObject.isFavorited ?? false
        skinEntity.top = skinObject.top ?? false
        skinEntity.new = skinObject.new ?? true
        
        if let imageData = skinEntity.imageData {
            skinEntity.imageData = imageData
        }

        do {
            try container.viewContext.save()
            skins.append(skinEntity)
        } catch {
            //ToDO: error
        }
    }
    
    mutating func appendMods(from modObject: ModPattern) {
        let modsEntity = Mod(context: container.viewContext)
        modsEntity.id = modObject.id
        modsEntity.title = modObject.title
        modsEntity.modDescriptions = modObject.description
        modsEntity.image = modObject.image
        modsEntity.file = modObject.file
        modsEntity.isFavorited = modObject.isFavorited ?? false
        modsEntity.top = modObject.top ?? false
        modsEntity.new = modObject.new ?? true
        
        if let imageData = modObject.imageData {
            modsEntity.imageData = imageData
        }

        do {
            try container.viewContext.save()
            mods.append(modsEntity)
        } catch {
            //ToDO: error
        }
    }

    mutating func appendMaps(from mapObject: MapPattern) {
        let mapsEntity = Map(context: container.viewContext)
        mapsEntity.id = mapObject.id
        mapsEntity.title = mapObject.title
        mapsEntity.mapDescriptions = mapObject.description
        mapsEntity.image = mapObject.image
        mapsEntity.file = mapObject.file
        mapsEntity.isFavorited = mapObject.isFavorited ?? false
        mapsEntity.top = mapObject.top ?? false
        mapsEntity.new = mapObject.new ?? true
        
        if let imageData = mapObject.imageData {
            mapsEntity.imageData = imageData
        }

        do {
            try container.viewContext.save()
            maps.append(mapsEntity)
        } catch {
           
        }
    }
    
    mutating func appendFarms(from farmObject: FarmModel) {
        let farmsEntity = Farm(context: container.viewContext)
        farmsEntity.id = farmObject.id
        farmsEntity.title = farmObject.title
        farmsEntity.farmDescriptions = farmObject.description
        farmsEntity.image = farmObject.image
        farmsEntity.file = farmObject.file
        farmsEntity.isFavorited = farmObject.isFavorited ?? false
        farmsEntity.top = farmObject.top ?? false
        farmsEntity.new = farmObject.new ?? true
        
        if let imageData = farmObject.imageData {
            farmsEntity.imageData = imageData
        }

        do {
            try container.viewContext.save()
            farms.append(farmsEntity)
        } catch {
            //ToDO: error
        }
    }

    func getSkins_SimulatorFarm() -> [SkinsPattern] {
        
        return skins.map({SkinsPattern(from: $0)})

    }
    
    
    func getMods_SimulatorFarm() -> [ModPattern] {
        
        
        
        
        return mods.map({ModPattern(from: $0)})

    }
    
    func getMaps_SimulatorFarm() -> [MapPattern] {
        
        
        
        return maps.map({MapPattern(from: $0)})

    }
    
    func getFarms_SimulatorFarm() -> [FarmModel] {
        
        
        
        return farms.map({FarmModel(from: $0)})

    }
    
    //Editor elements to coredata
    mutating func addBodyElements(_ skinsInput: [BodyEditorPattern], type: EditorTypePartOfBody) {
        for skin in skinsInput {
            appendBodyElement(from: skin, type: type)
        }
//        saveAll_SimulatorFarm()
    }
    
    mutating func appendBodyElement(from inputData: BodyEditorPattern, type: EditorTypePartOfBody){
        let itemEntity = BodyElement(context: container.viewContext)
        itemEntity.idElement = UUID()
        let genderInt: Int16 = genderToBodyElement(inputData.genderType)
        itemEntity.genderType = GenderTypeModel(rawValue: genderInt)?.rawValue ?? 0
        itemEntity.isNew = inputData.isNew
        itemEntity.isTop = inputData.isTop
        itemEntity.typeOfPart = type.rawValue
        itemEntity.zIndex = inputData.position
        itemEntity.previewImageString = inputData.smallImage
        itemEntity.editImageString = inputData.bigImage

        do {
            try container.viewContext.save()
        } catch {
            print("Cant save")
        }
    }
    
    private func genderToBodyElement(_ gender: GenderCoreData) -> Int16 {
        switch gender {
        case .boy:
            return 0
        case .girl:
            return 1
        }
    }
    //
    
    mutating func addSkins_SimulatorFarm(_ skinsInput: [SkinsPattern]) {
        for skin in skinsInput {
            appendSkin(from: skin)
        }
        saveAll_SimulatorFarm()
    }
    
    mutating func addMods_SimulatorFarm(_ mods: [ModPattern]) {
        for mod in mods {
            appendMods(from: mod)
        }
        saveAll_SimulatorFarm()
    }

    mutating func addMaps_SimulatorFarm(_ maps: [MapPattern]) {
        for map in maps {
            appendMaps(from: map)
        }
        saveAll_SimulatorFarm()
    }
    mutating func addFarms_SimulatorFarm(_ farms: [FarmModel]) {
        for farm in farms {
            appendFarms(from: farm)
        }
        saveAll_SimulatorFarm()
    }
    
    func updateSkins(with url: String, and data: Data) {
        if let imageEntity = skins.first(where: {$0.image == url.replacingOccurrences(of: DropBoxKeys_SimulatorFarm.skinsImagePartPath, with: "")}) {
            imageEntity.imageData = data
        }
        saveAll_SimulatorFarm()
    }
    
    func updateMods_SimulatorFarm_SimulatorFarm(with url: String, and data: Data) {
        if let imageEntity = mods.first(where: {$0.image == url.replacingOccurrences(of: DropBoxKeys_SimulatorFarm.modsImagePartPath, with: "")}) {
            imageEntity.imageData = data
        }
        saveAll_SimulatorFarm()
    }
    
    func updateMaps(with url: String, and data: Data) {
        if let imageEntity = maps.first(where: {$0.image == url.replacingOccurrences(of: DropBoxKeys_SimulatorFarm.mapsImagePartPath, with: "")}) {
            imageEntity.imageData = data
        }
        saveAll_SimulatorFarm()
    }
    
    func updateFarms(with url: String, and data: Data) {
        if let imageEntity = farms.first(where: {$0.image == url.replacingOccurrences(of: DropBoxKeys_SimulatorFarm.farmsImagePartPath, with: "")}) {
            imageEntity.imageData = data
        }
        saveAll_SimulatorFarm()
    }
    
    mutating func updateFavoriteSkins(with id: String) {
        skins = arrayOf_SimulatorFarm (Skins.self, context: container.viewContext) ?? []
        if let skin = skins.first(where: { $0.id == id}) {
            skin.isFavorited.toggle()
            saveAll_SimulatorFarm()
        }
        
    }
    
    mutating func updateFavoriteMods(with id: String) {
        mods = arrayOf_SimulatorFarm (Mod.self, context: container.viewContext) ?? []
        if let mod = mods.first(where: { $0.id == id}) {
            mod.isFavorited.toggle()
            saveAll_SimulatorFarm()
        }
        
    }
    
    mutating func updateFavoriteMaps(with id: String) {
        maps = arrayOf_SimulatorFarm (Map.self, context: container.viewContext) ?? []
        if let map = maps.first(where: { $0.id == id}) {
            map.isFavorited.toggle()
            saveAll_SimulatorFarm()
        }
        
    }
    
    mutating func updateFavoriteFarms(with id: String) {
        farms = arrayOf_SimulatorFarm (Farm.self, context: container.viewContext) ?? []
        if let farm = farms.first(where: { $0.id == id}) {
            farm.isFavorited.toggle()
            saveAll_SimulatorFarm()
        }
        
    }
    
    private func saveAll_SimulatorFarm() {
        
        //
        Task {
            await MainActor.run {
//                let viewContext = container.viewContext
                if container.viewContext.hasChanges {
                    do {
                        try container.viewContext.save()
                        print("Data saved to Core Data")
                    } catch {
                        print("Error saving data to Core Data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

