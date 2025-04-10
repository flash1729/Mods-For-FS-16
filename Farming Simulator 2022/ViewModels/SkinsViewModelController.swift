//
//  SkinsViewModel.swift
//  Farming Simulator 2022
//
//  Created by Sim on 29/09/24.
//

import Foundation
import SwiftUI
import CoreData

class SkinsViewModelController: ObservableObject {
    @Published var skins: [SkinsPattern] = []
    @Published var searchText = ""
    @Published var filteredSkins: [SkinsPattern] = []
    @Published var skinsSelectedFilter: FilterType_SimulatorFarm = .all
    @Published var filterFavoriteSkins: [SkinsPattern] = []
    var tempArrayToFilterSearch: [SkinsPattern] = []
    
    init() {
        fetchSkinsFromCoreData()
        listenForSkinPatternChanges()
        pressingfilterSkin()
        generateFavoriteSkin()
    }
    
    func generateFavoriteSkin() {
        filterFavoriteSkins = skins.filter { $0.isFavorited == true  }
    }
    
    func pressingfilterSkin() {
        switch skinsSelectedFilter {
        case .all:
            filteredSkins = skins
            tempArrayToFilterSearch = filteredSkins
        case .favorite:
            filteredSkins = filterFavoriteSkins
            tempArrayToFilterSearch = filteredSkins
        case .new:
            filteredSkins = skins.filter { $0.new! }
            tempArrayToFilterSearch = filteredSkins
        case .top:
            filteredSkins = skins.filter { $0.top! }
            tempArrayToFilterSearch = filteredSkins
        }
        if !searchText.isEmpty {
            filteredSkins = tempArrayToFilterSearch.filter { skin in
                return skin.title.lowercased().contains(searchText.lowercased())
                
            }
        }
    }
    
    
    func removeIsFavoriteMods(with id: String) {
        if skinsSelectedFilter == .favorite {
            if let removeIndex = filteredSkins.firstIndex(where: { $0.id == id }) {
                filteredSkins.remove(at: removeIndex)
            }
        }
    }
    
    func fetchSkinsFromCoreData() {
        print("Starting skins fetch from Core Data...")
        
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Skins> = Skins.fetchRequest()
        
        do {
            let fetchedSkins = try viewContext.fetch(fetchRequest)
            print("Successfully fetched skins. Count: \(fetchedSkins.count)")
            
            if fetchedSkins.isEmpty {
                print("Warning: No skins found in Core Data")
            } else {
                print("First skin title: \(fetchedSkins.first?.title ?? "no title")")
            }
            
            skins = fetchedSkins.map { skinEntity in
                return SkinsPattern(from: skinEntity)
            }
            
            print("Mapping complete. Final skins array count: \(skins.count)")
            pressingfilterSkin() // Ensure filtered data is updated
            print("Filtered skins count: \(filteredSkins.count)")
            
        } catch {
            print("Error fetching skins: \(error)")
            print("Detailed error description: \(error.localizedDescription)")
        }
    }
    
    func updateSkinsModel(updatedSkinModel: SkinsPattern) {
        if let index = skins.firstIndex(where: { $0.id == updatedSkinModel.id }) {
            skins[index] = updatedSkinModel
            NotificationCenter.default.post(name: NSNotification.Name("SkinPatternChanged"), object: self)
        }
    }
    
    func addDataToImage(data: Data, updatedItemModel: SkinsPattern) {
        if let index = skins.firstIndex(where: { $0.id == updatedItemModel.id }) {
            if skins[index].imageData != data {
                skins[index].imageData = data
                PersistenceController.shared.updateSkinImage(id: updatedItemModel.id, imageData: data)
                NotificationCenter.default.post(name: NSNotification.Name("SkinPatternChanged"), object: self)
            }
        }
    }

    private func listenForSkinPatternChanges() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("SkinPatternChanged"), object: nil, queue: nil) { notification in
            if let updatedSkin = notification.object as? SkinsPattern {
                if let index = self.skins.firstIndex(where: { $0.id == updatedSkin.id }) {
                    self.skins[index] = updatedSkin
                    self.generateFavoriteSkin()
                    
                }
            }
        }
    }
}
