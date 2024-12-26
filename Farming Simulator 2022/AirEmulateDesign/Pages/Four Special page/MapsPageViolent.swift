//
//  MapsPageViolent.swift
//  Farming Simulator 2022
//
//  Created by Sim on 24/09/24.
//

import SwiftUI

struct MapsPageViolent: View {
    @ObservedObject private var mapsViewModel = MapsViewModel_SimulatorFarm()
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var searchText: String = ""
    @State var filterType: IconTurboGear.FilterIconTurbo = .filterAllItems
    @State var choosedItem: MapPattern?
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
                AboutItemPageWithDownloadButton(titleItemName: choosedItem?.title ?? "", favoriteState: choosedItem?.isFavorited ?? false, imageData: choosedItem?.imageData, linkDownloadItem: "\(DropBoxKeys_SimulatorFarm.mapsFilePartPath)\(choosedItem?.file ?? "")", textItem: choosedItem?.description ?? "", idItemToLike: { bool in
                    if let choosedItem {
                        PersistenceController.shared.updateFavoriteMaps(with: choosedItem.id) //For every type diffierent
                    }
                    choosedLikeState = bool
                    let firstIndex = mapsViewModel.maps.firstIndex(where: {$0.id == choosedItem?.id})
                    if let firstIndex {
                        mapsViewModel.maps[firstIndex].isFavorited = bool
                        mapsViewModel.generateFavoriteMaps()
                        if mapsViewModel.mapsSelectedFilter == .favorite {
                            mapsViewModel.filteredMaps = mapsViewModel.filterFavoriteMaps
                            firstElementUpdate()
                        }
                        mapsViewModel.pressingfilterMaps()
                        collectionUpdateId = UUID()
                    }
                    choosedItem?.isFavorited = bool
                }, clearItemName: choosedItem?.file ?? "")
                    .navigationBarBackButtonHidden()
            }, label: {EmptyView()})
            VStack(spacing: bigSize ? 20 : 12) {
                NavPanelSearchInsideCyan(searchText: $searchText, filterType: $filterType, searchTypeElement: .maps, onCommit: {}, choosedFilter: {item in
                    switch item {
                    case .filterAllItems:
                        mapsViewModel.mapsSelectedFilter = .all
                    case .filterNewItems:
                        mapsViewModel.mapsSelectedFilter = .new
                    case .filterFavoriteItems:
                        mapsViewModel.mapsSelectedFilter = .favorite
                    case .filterTopItems:
                        mapsViewModel.mapsSelectedFilter = .top
                    }
                    mapsViewModel.pressingfilterMaps()
                    firstElementUpdate()
                })
                .padding(.bottom, bigSize ? 30 : 0)
                ZStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                        }
                    if mapsViewModel.filteredMaps.isEmpty {
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
                mapsViewModel.searchText = searchText
                mapsViewModel.pressingfilterMaps()
                firstElementUpdate()
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("MapPatternChanged"), object: nil, queue: nil) { notification in
                    if let updatedMaps = notification.object as? MapPattern {
                        if let index = mapsViewModel.maps.firstIndex(where: { $0.id == updatedMaps.id }) {
                            mapsViewModel.maps[index] = updatedMaps
                            mapsViewModel.generateFavoriteMaps()
                        }
                    }
                }
                if !ifOpenAboutPage {
                    mapsViewModel.mapsSelectedFilter = .all
                    firstElementUpdate()
                }
                ifOpenAboutPage = false
                mapsViewModel.pressingfilterMaps()
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
        if !mapsViewModel.filteredMaps.isEmpty {
            choosedItem = mapsViewModel.filteredMaps.first
            choosedImageName = "\(DropBoxKeys_SimulatorFarm.mapsImagePartPath)\(choosedItem?.image ?? "")"
            choosedLikeState = choosedItem?.isFavorited ?? false
            updateId = UUID()
        }
    }
    
    private var bodyMiddleSection: some View {
        
        PreviewItemFromRemote(imageData: choosedItem?.imageData, imagePath: "\(DropBoxKeys_SimulatorFarm.mapsImagePartPath)\(choosedItem?.image ?? "")", titleData: choosedItem?.title, previewText: choosedItem?.description, likeState: $choosedLikeState, tappedLikeButton: {bool in
            choosedItem?.isFavorited = bool
            if let idString = choosedItem?.id {
                PersistenceController.shared.updateFavoriteMaps(with: idString)
            }
            let firstIndex = mapsViewModel.maps.firstIndex(where: {$0.id == choosedItem?.id})
            if let firstIndex {
                mapsViewModel.maps[firstIndex].isFavorited = bool
                mapsViewModel.generateFavoriteMaps()
                if mapsViewModel.mapsSelectedFilter == .favorite {
                    mapsViewModel.filteredMaps = mapsViewModel.filterFavoriteMaps
                    firstElementUpdate()
                }
                mapsViewModel.pressingfilterMaps()
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
                        mapsViewModel.addDataToImage(data: sendData, updatedItemModel: choosedItem)
                        mapsViewModel.updateMapModel(updatedMapModel: choosedItem)
                        mapsViewModel.fetchMapsFromCoreData()
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
                    ForEach(mapsViewModel.filteredMaps, id: \.id) { item in
                        ElementCellDataCyanBorder(imageName: "\(DropBoxKeys_SimulatorFarm.mapsImagePartPath)\(item.image)", choosedImageName: $choosedImageName, tappedOnImage: {
                            choosedImageName = "\(DropBoxKeys_SimulatorFarm.mapsImagePartPath)\(item.image)"
                            choosedLikeState = item.isFavorited ?? false
                            let firstItem = mapsViewModel.maps.first(where: {$0.id == item.id})
                            if let firstItem {
                                choosedItem = firstItem
                            }
                            if mapsViewModel.mapsSelectedFilter == .favorite {
                                collectionUpdateId = UUID()
                            }
                            updateId = UUID()
                        }, imageData: item.imageData, sendBackImageData: {sendData in
                            Task {
                                await MainActor.run {
                                    mapsViewModel.addDataToImage(data: sendData, updatedItemModel: item)
                                    mapsViewModel.updateMapModel(updatedMapModel: item)
                                    mapsViewModel.fetchMapsFromCoreData()
                                    let firstIndex = mapsViewModel.maps.firstIndex(where: {$0.id == item.id})
                                    if let firstIndex {
                                        mapsViewModel.maps[firstIndex].imageData = sendData
                                        if choosedItem?.image == item.image{
                                            choosedItem?.imageData = sendData
                                            updateId = UUID()
                                        }
                                        mapsViewModel.pressingfilterMaps()
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
    MapsPageViolent()
        .environmentObject(NetworkManager_SimulatorFarm())
}
