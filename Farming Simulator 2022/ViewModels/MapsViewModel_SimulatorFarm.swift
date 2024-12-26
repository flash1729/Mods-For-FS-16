//
//  MapsViewModel_SimulatorFarm.swift
//  Farming Simulator 2022
//
//  Created by Systems
//

import Foundation
import SwiftUI
import CoreData

class MapsViewModel_SimulatorFarm: ObservableObject {
    @Published var maps: [MapPattern] = []
    @Published var searchText = ""
    @Published var filteredMaps: [MapPattern] = []
    @Published var mapsSelectedFilter: FilterType_SimulatorFarm = .all
    @Published var filterFavoriteMaps: [MapPattern] = []
    var tempArrayToFilterSearch: [MapPattern] = []
    init() {
        

        fetchMapsFromCoreData()
        listenForMapPatternChanges()
        pressingfilterMaps()
        generateFavoriteMaps()
        
    }
    
    func generateFavoriteMaps() {
        filterFavoriteMaps = maps.filter { $0.isFavorited == true }
    }
    
    func pressingfilterMaps() {
        switch mapsSelectedFilter {
        case .all:
            filteredMaps = maps
            tempArrayToFilterSearch = filteredMaps
        case .favorite:
            filteredMaps = filterFavoriteMaps
            tempArrayToFilterSearch = filteredMaps
        case .new:
            filteredMaps = maps.filter { $0.new! }
            tempArrayToFilterSearch = filteredMaps
        case .top:
            filteredMaps = maps.filter { $0.top! }
            tempArrayToFilterSearch = filteredMaps
        }
        
        if !searchText.isEmpty {
            filteredMaps = tempArrayToFilterSearch.filter { map in
                return map.title.lowercased().contains(searchText.lowercased())
            }
        }

    }


    
    
    func removeIsFavoriteMap(with id: String) {
        if mapsSelectedFilter == .favorite {
            if let removeIndex = filteredMaps.firstIndex(where: { $0.id == id }) {
                filteredMaps.remove(at: removeIndex)
            }
        }
    }
    

    // MARK: - Fetch Maps Data from Core Data
     func fetchMapsFromCoreData() {
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Map> = Map.fetchRequest()
        do {
            let fetchedMaps = try viewContext.fetch(fetchRequest)
            print("++ maps fetched \(fetchedMaps.count)")
            maps = fetchedMaps.map { mapEntity in
                return MapPattern(from: mapEntity)
            }
            
        } catch {
            print("Error fetching maps: \(error)")
        }
    }

    func updateMapModel(updatedMapModel: MapPattern) {
        if let index = maps.firstIndex(where: { $0.id == updatedMapModel.id }) {
            maps[index] = updatedMapModel

            NotificationCenter.default.post(name: NSNotification.Name("MapPatternChanged"), object: self)
        }
    }
    
    func addDataToImage(data: Data, updatedItemModel: MapPattern) {
        if let index = maps.firstIndex(where: { $0.id == updatedItemModel.id }) {
            maps[index].imageData = data
            NotificationCenter.default.post(name: NSNotification.Name("MapPatternChanged"), object: self)
        }
    }
    
    // MARK: - Listen for MapPattern Changes
    private func listenForMapPatternChanges() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("MapPatternChanged"), object: nil, queue: nil) { notification in
            if let updatedMap = notification.object as? MapPattern {
                if let index = self.maps.firstIndex(where: { $0.id == updatedMap.id }) {
                    self.maps[index] = updatedMap
//                    self.pressingfilterMaps()
                    self.generateFavoriteMaps()
                }
            }
        }
    }
}
