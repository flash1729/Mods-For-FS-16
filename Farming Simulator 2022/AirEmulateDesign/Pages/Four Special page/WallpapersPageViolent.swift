//
//  PlanePageViolent.swift
//  Farming Simulator 2022
//
//  Created by Sim on 24/09/24.
//

import SwiftUI

struct WallpapersPageViolent: View {
    @ObservedObject private var farmViewModel = FarmsViewModel()
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var searchText: String = ""
    @State var filterType: IconTurboGear.FilterIconTurbo = .filterAllItems
    @State var choosedItem: FarmModel?
    @State var choosedLikeState: Bool = false
    @State var choosedImageName: String = ""
    @State var updateId: UUID = UUID()
    @State var collectionUpdateId: UUID = UUID()
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    @State var workInternetState: Bool = true
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @State var timer: Timer?
    
    @State var openAboutPage: Bool = false
    @State var ifOpenAboutPage: Bool = false
    var body: some View {
        ZStack {
            NavigationLink(isActive: $openAboutPage, destination: {
                AboutItemPageWithDownloadButton(titleItemName: choosedItem?.title ?? "", favoriteState: choosedItem?.isFavorited ?? false, imageData: choosedItem?.imageData, linkDownloadItem: nil, textItem: choosedItem?.description ?? "", idItemToLike: { bool in
                    if let choosedItem {
                        PersistenceController.shared.updateFavoriteFarms(with: choosedItem.id) //For every type diffierent
                    }
                    choosedLikeState = bool
                    let firstIndex = farmViewModel.farms.firstIndex(where: {$0.id == choosedItem?.id})
                    if let firstIndex {
                        farmViewModel.farms[firstIndex].isFavorited = bool
                        farmViewModel.generateFavoriteFarms()
                        if farmViewModel.farmsSelectedFilter == .favorite {
                            farmViewModel.filteredFarms = farmViewModel.filterFavoriteFarms
                            firstElementUpdate()
                        }
                        farmViewModel.pressingFilterFarms()
                        collectionUpdateId = UUID()
                    }
                    choosedItem?.isFavorited = bool
                }, clearItemName: "")
                    .navigationBarBackButtonHidden()
            }, label: {EmptyView()})
            VStack(spacing: bigSize ? 20 : 12) {
                NavPanelSearchInsideCyan(searchText: $searchText, filterType: $filterType, searchTypeElement: .plane, onCommit: {}, choosedFilter: {item in
                    switch item {
                    case .filterAllItems:
                        farmViewModel.farmsSelectedFilter = .all
                    case .filterNewItems:
                        farmViewModel.farmsSelectedFilter = .new
                    case .filterFavoriteItems:
                        farmViewModel.farmsSelectedFilter = .favorite
                    case .filterTopItems:
                        farmViewModel.farmsSelectedFilter = .top
                    }
                    farmViewModel.pressingFilterFarms()
                    firstElementUpdate()
                }, showSearchPanel: false)
                .padding(.bottom, bigSize ? 30 : 0)
                ZStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                        }
                    if farmViewModel.filteredFarms.isEmpty {
                        Text("No result found")
                            .font(FontTurboGear.montserratStyle(size: 24, type: .medium))
                            .foregroundColor(.white)
                            .padding(.top, 100)
                    } else {
                        VStack(spacing: bigSize ? 20 : 12) {
                            bodyMiddleSection
                                .paddingFlyBullet()
                                .frame(maxHeight: .infinity)
                            bottomSection
                        }
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            .frame(maxHeight: .infinity, alignment: .top)
            .onChange(of: searchText) { _ in
                farmViewModel.searchText = searchText
                farmViewModel.pressingFilterFarms()
                firstElementUpdate()
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("FarmModelChanged"), object: nil, queue: nil) { notification in
                    if let updatedMaps = notification.object as? FarmModel {
                        if let index = farmViewModel.farms.firstIndex(where: { $0.id == updatedMaps.id }) {
                            farmViewModel.farms[index] = updatedMaps
                            farmViewModel.generateFavoriteFarms()
                        }
                    }
                }
                if !ifOpenAboutPage {
                    farmViewModel.farmsSelectedFilter = .all
                    firstElementUpdate()
                }
                ifOpenAboutPage = false
                farmViewModel.pressingFilterFarms()
            }
            if !workInternetState {
                LostConnectElement {
                    workInternetState.toggle()
                    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                        if workInternetState {
                            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
                        }
                    }
                }
            }
        }
        .onAppear(){
            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
        }
        .onDisappear(){
            timer?.invalidate()
        }
    }
    
    private func firstElementUpdate() {
        if !farmViewModel.filteredFarms.isEmpty {
            choosedItem = farmViewModel.filteredFarms.first
            choosedImageName = "\(DropBoxKeys_SimulatorFarm.farmsImagePartPath)\(choosedItem?.image ?? "")"
            choosedLikeState = choosedItem?.isFavorited ?? false
            updateId = UUID()
        }
    }
    
    private var bodyMiddleSection: some View {
        
        PreviewItemFromRemote(imageData: choosedItem?.imageData, imagePath: "\(DropBoxKeys_SimulatorFarm.farmsImagePartPath)\(choosedItem?.image ?? "")", titleData: choosedItem?.title, previewText: choosedItem?.description, likeState: $choosedLikeState, tappedLikeButton: {bool in
            choosedItem?.isFavorited = bool
            if let idString = choosedItem?.id {
                PersistenceController.shared.updateFavoriteFarms(with: idString)
            }
            let firstIndex = farmViewModel.farms.firstIndex(where: {$0.id == choosedItem?.id})
            if let firstIndex {
                farmViewModel.farms[firstIndex].isFavorited = bool
                farmViewModel.generateFavoriteFarms()
                if farmViewModel.farmsSelectedFilter == .favorite {
                    farmViewModel.filteredFarms = farmViewModel.filterFavoriteFarms
                    firstElementUpdate()
                }
                farmViewModel.pressingFilterFarms()
                collectionUpdateId = UUID()
            }
        }, openDescriptionItem: {
            if choosedItem?.imageData != nil {
                ifOpenAboutPage = true
                openAboutPage.toggle()
            }
        }, sendBackImageData: {sendData in
            Task {
                await MainActor.run {
                    if let choosedItem {
                        farmViewModel.addDataToImage(data: sendData, updatedItemModel: choosedItem)
                        farmViewModel.updateFarmModel(updatedFarmModel: choosedItem)
                        farmViewModel.fetchFarmsFromCoreData()
                    }
                }
            }
        })
        .id(updateId)
    }
    
    private var bottomSection: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: bigSize ? 20 : 10) {
                    ForEach(farmViewModel.filteredFarms, id: \.id) { item in
                        ElementCellDataCyanBorder(imageName: "\(DropBoxKeys_SimulatorFarm.farmsImagePartPath)\(item.image)", choosedImageName: $choosedImageName, tappedOnImage: {
                            choosedImageName = "\(DropBoxKeys_SimulatorFarm.farmsImagePartPath)\(item.image)"
                            choosedLikeState = item.isFavorited ?? false
                            let firstItem = farmViewModel.farms.first(where: {$0.id == item.id})
                            if let firstItem {
                                choosedItem = firstItem
                            }
                            if farmViewModel.farmsSelectedFilter == .favorite {
                                collectionUpdateId = UUID()
                            }
                            updateId = UUID()
                        }, imageData: item.imageData, sendBackImageData: {sendData in
                            Task {
                                await MainActor.run {
                                    farmViewModel.addDataToImage(data: sendData, updatedItemModel: item)
                                    farmViewModel.updateFarmModel(updatedFarmModel: item)
                                    farmViewModel.fetchFarmsFromCoreData()
                                    let firstIndex = farmViewModel.farms.firstIndex(where: {$0.id == item.id})
                                    if let firstIndex {
                                        farmViewModel.farms[firstIndex].imageData = sendData
                                        if choosedItem?.image == item.image{
                                            choosedItem?.imageData = sendData
                                            updateId = UUID()
                                        }
                                        farmViewModel.pressingFilterFarms()
                                    }
                                }
                            }
                        })
                        .id(collectionUpdateId)
                        .id(item.id)
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                    }
                }
                .padding(.leading, bigSize ? 40 : 20)
                .padding(.bottom, 5)
                .onAppear() {
                    scrollProxy = proxy
                }
            }
            .onAppear() {
                withAnimation {
                    scrollProxy?.scrollTo(choosedItem?.id, anchor: .center)
                }
            }
            .onChange(of: choosedItem, perform: { value in
                withAnimation {
                    scrollProxy?.scrollTo(choosedItem?.id, anchor: .center)
                }
            })
        }
        .frame(height: bigSize ? 200 : 110)
        .padding(.vertical, bigSize ? 30 : 10)
    }
}

#Preview {
    WallpapersPageViolent()
}
