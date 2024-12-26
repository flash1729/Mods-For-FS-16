//
//  FarmsViewModel.swift
//  Farming Simulator 2022
//
//  Created by Systems
//

import Foundation
import SwiftUI
import CoreData

class FarmsViewModel: ObservableObject {
    @Published var farms: [FarmModel] = []
    @Published var searchText = ""
    @Published var filteredFarms: [FarmModel] = []
    @Published var farmsSelectedFilter: FilterType_SimulatorFarm = .all
    @Published var filterFavoriteFarms: [FarmModel] = []

    
    init() {
        
        fetchFarmsFromCoreData()
        listenForFarmModelChanges()
        pressingFilterFarms()
        generateFavoriteFarms()
    }
    
    func generateFavoriteFarms() {
        filterFavoriteFarms = farms.filter { $0.isFavorited == true  }
    }
    
    func pressingFilterFarms() {
        switch farmsSelectedFilter {
        case .all:
            filteredFarms = farms
        case .favorite:
            filteredFarms = filterFavoriteFarms
        case .new:
            filteredFarms = farms.filter { $0.new! }
        case .top:
            filteredFarms = farms.filter { $0.top! }
        }
        
        if !searchText.isEmpty {
            filteredFarms = farms.filter { farm in
                return farm.image.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    
    func removeIsFavoriteFarm(with id: String) {
        if farmsSelectedFilter == .favorite {
            if let removeIndex = filteredFarms.firstIndex(where: { $0.id == id }) {
                filteredFarms.remove(at: removeIndex)
            }
        }
    }

    func fetchFarmsFromCoreData() {
       let viewContext = PersistenceController.shared.container.viewContext
       let fetchRequest: NSFetchRequest<Farm> = Farm.fetchRequest()
       do {
           let fetchedFarms = try viewContext.fetch(fetchRequest)
               farms = fetchedFarms.map { farmEntity in
                   return FarmModel(from: farmEntity)
               }
           
       } catch {
           print("Error fetching farms: \(error)")
       }
   }


    func updateFarmModel(updatedFarmModel: FarmModel) {
        if let index = farms.firstIndex(where: { $0.id == updatedFarmModel.id }) {
            farms[index] = updatedFarmModel

            NotificationCenter.default.post(name: NSNotification.Name("FarmModelChanged"), object: self)
        }
    }
    
    func addDataToImage(data: Data, updatedItemModel: FarmModel) {
        if let index = farms.firstIndex(where: { $0.id == updatedItemModel.id }) {
            farms[index].imageData = data
            NotificationCenter.default.post(name: NSNotification.Name("FarmModelChanged"), object: self)
        }
    }

    private func listenForFarmModelChanges() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("FarmModelChanged"), object: nil, queue: nil) { notification in
            if let updatedFarm = notification.object as? FarmModel {
                if let index = self.farms.firstIndex(where: { $0.id == updatedFarm.id }) {
                    self.farms[index] = updatedFarm
                    self.generateFavoriteFarms()
                }
            }
        }
    }

}

