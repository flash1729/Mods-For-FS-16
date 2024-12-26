//
//  ModsViewModel.swift
//  Farming Simulator 2022
//
//  Created by Systems
//

import Foundation
import SwiftUI
import CoreData

class ModViewModel: ObservableObject {
    @Published var mods: [ModPattern] = []
    @Published var searchText = ""
    @Published var filteredMods: [ModPattern] = []
    @Published var modsSelectedFilter: FilterType_SimulatorFarm = .all 
    @Published var filterFavoriteMods: [ModPattern] = []
    var tempArrayToFilterSearch: [ModPattern] = []

    init() {
        

        fetchModsFromCoreData()
        listenForModPatternChanges()
        pressingfilterMods()
        generateFavoriteMods()
    }
    
    func generateFavoriteMods() {
        filterFavoriteMods = mods.filter { $0.isFavorited == true  }
    }
    
    func pressingfilterMods() {
        switch modsSelectedFilter {
        case .all:
            filteredMods = mods
            tempArrayToFilterSearch = filteredMods
        case .favorite:
            filteredMods = filterFavoriteMods
            tempArrayToFilterSearch = filteredMods
        case .new:
            filteredMods = mods.filter { $0.new! }
            tempArrayToFilterSearch = filteredMods
        case .top:
            filteredMods = mods.filter { $0.top! }
            tempArrayToFilterSearch = filteredMods
        }
        if !searchText.isEmpty {
            filteredMods = tempArrayToFilterSearch.filter { mod in
                return mod.title.lowercased().contains(searchText.lowercased())
                
            }
        }
    }
    
    
    func removeIsFavoriteMods(with id: String) {
        if modsSelectedFilter == .favorite {
            if let removeIndex = filteredMods.firstIndex(where: { $0.id == id }) {
                filteredMods.remove(at: removeIndex)
            }
        }
    }
    
     func fetchModsFromCoreData() {
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Mod> = Mod.fetchRequest()
        do {
            let fetchedMods = try viewContext.fetch(fetchRequest)
                mods = fetchedMods.map { modEntity in
                    return ModPattern(from: modEntity)
                }
            
        } catch {
            print("Error fetching mods: \(error)")
        }
    }
    
    func updateModModel(updatedModModel: ModPattern) {
        if let index = mods.firstIndex(where: { $0.id == updatedModModel.id }) {
            mods[index] = updatedModModel
            NotificationCenter.default.post(name: NSNotification.Name("ModPatternChanged"), object: self)
        }
    }
    
    func addDataToImage(data: Data, updatedItemModel: ModPattern) {
        if let index = mods.firstIndex(where: { $0.id == updatedItemModel.id }) {
            mods[index].imageData = data
            NotificationCenter.default.post(name: NSNotification.Name("ModPatternChanged"), object: self)
        }
    }

    private func listenForModPatternChanges() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ModPatternChanged"), object: nil, queue: nil) { notification in
            if let updatedMod = notification.object as? ModPattern {
                if let index = self.mods.firstIndex(where: { $0.id == updatedMod.id }) {
                    self.mods[index] = updatedMod
                    self.generateFavoriteMods()
                    
                }
            }
        }
    }
}
