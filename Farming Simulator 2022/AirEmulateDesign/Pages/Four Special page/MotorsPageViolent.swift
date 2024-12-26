//
//  MotorsPageViolent.swift
//  Farming Simulator 2022
//
//  Created by Sim on 24/09/24.
//

import SwiftUI

struct MotorsPageViolent: View {
    @ObservedObject private var dadsViewModel = ModViewModel()
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var searchText: String = ""
    @State var filterType: IconTurboGear.FilterIconTurbo = .filterAllItems
    @State var choosedItem: ModPattern?
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
                AboutItemPageWithDownloadButton(titleItemName: choosedItem?.title ?? "", favoriteState: choosedItem?.isFavorited ?? false, imageData: choosedItem?.imageData, linkDownloadItem: "\(DropBoxKeys_SimulatorFarm.modsFilePartPath)\(choosedItem?.file ?? "")", textItem: choosedItem?.description ?? "", idItemToLike: { bool in
                    if let choosedItem {
                        PersistenceController.shared.updateFavoriteMods(with: choosedItem.id) //For every type diffierent
                    }
                    choosedLikeState = bool
                    let firstIndex = dadsViewModel.mods.firstIndex(where: {$0.id == choosedItem?.id})
                    if let firstIndex {
                        dadsViewModel.mods[firstIndex].isFavorited = bool
                        dadsViewModel.generateFavoriteMods()
                        if dadsViewModel.modsSelectedFilter == .favorite {
                            dadsViewModel.filteredMods = dadsViewModel.filterFavoriteMods
                            firstElementUpdate()
                        }
                        dadsViewModel.pressingfilterMods()
                        collectionUpdateId = UUID()
                    }
                    choosedItem?.isFavorited = bool
                }, clearItemName: choosedItem?.file ?? "")
                    .navigationBarBackButtonHidden()
            }, label: {EmptyView()})
            VStack(spacing: bigSize ? 20 : 12) {
                NavPanelSearchInsideCyan(searchText: $searchText, filterType: $filterType, searchTypeElement: .dads, onCommit: {}, choosedFilter: {item in
                    switch item {
                    case .filterAllItems:
                        dadsViewModel.modsSelectedFilter = .all
                    case .filterNewItems:
                        dadsViewModel.modsSelectedFilter = .new
                    case .filterFavoriteItems:
                        dadsViewModel.modsSelectedFilter = .favorite
                    case .filterTopItems:
                        dadsViewModel.modsSelectedFilter = .top
                    }
                    dadsViewModel.pressingfilterMods()
                    firstElementUpdate()
                })
                .padding(.bottom, bigSize ? 30 : 0)
                ZStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                        }
                    if dadsViewModel.filteredMods.isEmpty {
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
                dadsViewModel.searchText = searchText
                dadsViewModel.pressingfilterMods()
                firstElementUpdate()
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("ModPatternChanged"), object: nil, queue: nil) { notification in
                    if let updatedMod = notification.object as? ModPattern {
                        if let index = dadsViewModel.mods.firstIndex(where: { $0.id == updatedMod.id }) {
                            dadsViewModel.mods[index] = updatedMod
                            dadsViewModel.generateFavoriteMods()
                        }
                    }
                }
                if !ifOpenAboutPage {
                    dadsViewModel.modsSelectedFilter = .all
                    firstElementUpdate()
                }
                ifOpenAboutPage = false
                dadsViewModel.pressingfilterMods()
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
        if !dadsViewModel.filteredMods.isEmpty {
            choosedItem = dadsViewModel.filteredMods.first
            choosedImageName = "\(DropBoxKeys_SimulatorFarm.modsImagePartPath)\(choosedItem?.image ?? "")"
            choosedLikeState = choosedItem?.isFavorited ?? false
            updateId = UUID()
        }
    }
    
    private var bodyMiddleSection: some View {
        PreviewItemFromRemote(imageData: choosedItem?.imageData, imagePath: "\(DropBoxKeys_SimulatorFarm.modsImagePartPath)\(choosedItem?.image ?? "")", titleData: choosedItem?.title, previewText: choosedItem?.description, likeState: $choosedLikeState, tappedLikeButton: {bool in
            choosedItem?.isFavorited = bool
            if let idString = choosedItem?.id {
                PersistenceController.shared.updateFavoriteMods(with: idString)
            }
            let firstIndex = dadsViewModel.mods.firstIndex(where: {$0.id == choosedItem?.id})
            if let firstIndex {
                dadsViewModel.mods[firstIndex].isFavorited = bool
                dadsViewModel.generateFavoriteMods()
                if dadsViewModel.modsSelectedFilter == .favorite {
                    dadsViewModel.filteredMods = dadsViewModel.filterFavoriteMods
                    firstElementUpdate()
                }
                dadsViewModel.pressingfilterMods()
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
                        dadsViewModel.addDataToImage(data: sendData, updatedItemModel: choosedItem)
                        dadsViewModel.updateModModel(updatedModModel: choosedItem)
                        dadsViewModel.fetchModsFromCoreData()
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
                    ForEach(dadsViewModel.filteredMods, id: \.id) { item in
                        ElementCellDataCyanBorder(imageName: "\(DropBoxKeys_SimulatorFarm.modsImagePartPath)\(item.image)", choosedImageName: $choosedImageName, tappedOnImage: {
                            choosedImageName = "\(DropBoxKeys_SimulatorFarm.modsImagePartPath)\(item.image)"
                            choosedLikeState = item.isFavorited ?? false
                            let firstItem = dadsViewModel.mods.first(where: {$0.id == item.id})
                            if let firstItem {
                                choosedItem = firstItem
                            }
                            if dadsViewModel.modsSelectedFilter == .favorite {
                                collectionUpdateId = UUID()
                            }
                            updateId = UUID()
                        }, imageData: item.imageData, sendBackImageData: {sendData in
                            Task {
                                await MainActor.run {
                                    dadsViewModel.addDataToImage(data: sendData, updatedItemModel: item)
                                    dadsViewModel.updateModModel(updatedModModel: item)
                                    dadsViewModel.fetchModsFromCoreData()
                                    let firstIndex = dadsViewModel.mods.firstIndex(where: {$0.id == item.id})
                                    if let firstIndex {
                                        dadsViewModel.mods[firstIndex].imageData = sendData
                                        if choosedItem?.image == item.image{
                                            choosedItem?.imageData = sendData
                                            updateId = UUID()
                                        }
                                        dadsViewModel.pressingfilterMods()
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
    MotorsPageViolent()
}
