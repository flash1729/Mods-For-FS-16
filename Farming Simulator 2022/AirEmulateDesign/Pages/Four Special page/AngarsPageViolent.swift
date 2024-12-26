//
//  AngarsPageViolent.swift
//  Farming Simulator 2022
//
//  Created by Sim on 24/09/24.
//

import SwiftUI

struct AngarsPageViolent: View {
    @ObservedObject private var skinsViewModel = SkinsViewModel()
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var searchText: String = ""
    @State var filterType: IconTurboGear.FilterIconTurbo = .filterAllItems
    @State var choosedItem: SkinsPattern?
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
                AboutItemPageWithDownloadButton(titleItemName: choosedItem?.title ?? "", favoriteState: choosedItem?.isFavorited ?? false, imageData: choosedItem?.imageData, linkDownloadItem: "\(DropBoxKeys_SimulatorFarm.skinFilePartPath)\(choosedItem?.file ?? "")", textItem: choosedItem?.description ?? "", idItemToLike: { bool in
                    if let choosedItem {
                        PersistenceController.shared.updateFavoriteSkins(with: choosedItem.id) //For every type diffierent
                    }
                    choosedLikeState = bool
                    let firstIndex = skinsViewModel.skins.firstIndex(where: {$0.id == choosedItem?.id})
                    if let firstIndex {
                        skinsViewModel.skins[firstIndex].isFavorited = bool
                        skinsViewModel.generateFavoriteSkin()
                        if skinsViewModel.skinsSelectedFilter == .favorite {
                            skinsViewModel.filteredSkins = skinsViewModel.filterFavoriteSkins
                            firstElementUpdate()
                        }
                        skinsViewModel.pressingfilterSkin()
                        collectionUpdateId = UUID()
                    }
                    choosedItem?.isFavorited = bool
                }, clearItemName: choosedItem?.file ?? "")
                    .navigationBarBackButtonHidden()
            }, label: {EmptyView()})
            VStack(spacing: bigSize ? 20 : 12) {
                NavPanelSearchInsideCyan(searchText: $searchText, filterType: $filterType, searchTypeElement: .farm, onCommit: {}, choosedFilter: {item in
                    switch item {
                    case .filterAllItems:
                        skinsViewModel.skinsSelectedFilter = .all
                    case .filterNewItems:
                        skinsViewModel.skinsSelectedFilter = .new
                    case .filterFavoriteItems:
                        skinsViewModel.skinsSelectedFilter = .favorite
                    case .filterTopItems:
                        skinsViewModel.skinsSelectedFilter = .top
                    }
                    skinsViewModel.pressingfilterSkin()
                    firstElementUpdate()
                })
                .padding(.bottom, bigSize ? 30 : 0)
                ZStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                        }
                    if skinsViewModel.filteredSkins.isEmpty {
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
                skinsViewModel.searchText = searchText
                skinsViewModel.pressingfilterSkin()
                firstElementUpdate()
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("SkinPatternChanged"), object: nil, queue: nil) { notification in
                    if let updatedMod = notification.object as? SkinsPattern {
                        if let index = skinsViewModel.skins.firstIndex(where: { $0.id == updatedMod.id }) {
                            skinsViewModel.skins[index] = updatedMod
                            skinsViewModel.generateFavoriteSkin()
                        }
                    }
                }
                if !ifOpenAboutPage {
                    skinsViewModel.skinsSelectedFilter = .all
                    firstElementUpdate()
                }
                ifOpenAboutPage = false
                skinsViewModel.pressingfilterSkin()
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
        if !skinsViewModel.filteredSkins.isEmpty {
            choosedItem = skinsViewModel.filteredSkins.first
            choosedImageName = "\(DropBoxKeys_SimulatorFarm.skinsImagePartPath)\(choosedItem?.image ?? "")"
            choosedLikeState = choosedItem?.isFavorited ?? false
            updateId = UUID()
        }
    }
    
    private var bodyMiddleSection: some View {
        PreviewItemFromRemote(imageData: choosedItem?.imageData, imagePath: "\(DropBoxKeys_SimulatorFarm.skinsImagePartPath)\(choosedItem?.image ?? "")", titleData: choosedItem?.title, previewText: choosedItem?.description, likeState: $choosedLikeState, tappedLikeButton: {bool in
            choosedItem?.isFavorited = bool
            if let idString = choosedItem?.id {
                PersistenceController.shared.updateFavoriteSkins(with: idString)
            }
            let firstIndex = skinsViewModel.skins.firstIndex(where: {$0.id == choosedItem?.id})
            if let firstIndex {
                skinsViewModel.skins[firstIndex].isFavorited = bool
                skinsViewModel.generateFavoriteSkin()
                if skinsViewModel.skinsSelectedFilter == .favorite {
                    skinsViewModel.filteredSkins = skinsViewModel.filterFavoriteSkins
                    firstElementUpdate()
                }
                skinsViewModel.pressingfilterSkin()
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
                        skinsViewModel.addDataToImage(data: sendData, updatedItemModel: choosedItem)
                        skinsViewModel.updateSkinsModel(updatedSkinModel: choosedItem)
                        skinsViewModel.fetchSkinsFromCoreData()
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
                    ForEach(skinsViewModel.filteredSkins, id: \.id) { item in
                        ElementCellDataCyanBorder(imageName: "\(DropBoxKeys_SimulatorFarm.skinsImagePartPath)\(item.image)", choosedImageName: $choosedImageName, tappedOnImage: {
                            choosedImageName = "\(DropBoxKeys_SimulatorFarm.skinsImagePartPath)\(item.image)"
                            choosedLikeState = item.isFavorited ?? false
                            let firstItem = skinsViewModel.skins.first(where: {$0.id == item.id})
                            if let firstItem {
                                choosedItem = firstItem
                            }
                            if skinsViewModel.skinsSelectedFilter == .favorite {
                                collectionUpdateId = UUID()
                            }
                            updateId = UUID()
                        }, imageData: item.imageData, sendBackImageData: {sendData in
                            Task {
                                await MainActor.run {
                                    skinsViewModel.addDataToImage(data: sendData, updatedItemModel: item)
                                    skinsViewModel.updateSkinsModel(updatedSkinModel: item)
                                    skinsViewModel.fetchSkinsFromCoreData()
                                    let firstIndex = skinsViewModel.skins.firstIndex(where: {$0.id == item.id})
                                    if let firstIndex {
                                        skinsViewModel.skins[firstIndex].imageData = sendData
                                        if choosedItem?.image == item.image{
                                            choosedItem?.imageData = sendData
                                            updateId = UUID()
                                        }
                                        skinsViewModel.pressingfilterSkin()
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
    AngarsPageViolent()
}
