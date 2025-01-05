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
                Color.white
                    .ignoresSafeArea()
                
                NavigationLink(isActive: $openAboutPage, destination: {
                    AboutItemPageWithDownloadButton(
                        titleItemName: choosedItem?.title ?? "",
                        favoriteState: choosedItem?.isFavorited ?? false,
                        imageData: choosedItem?.imageData,
                        linkDownloadItem: "\(DropBoxKeys_SimulatorFarm.farmsImagePartPath)\(choosedItem?.file ?? "")",
                        textItem: choosedItem?.description ?? "",
                        idItemToLike: { bool in
                            if let choosedItem {
                                PersistenceController.shared.updateFavoriteFarms(with: choosedItem.id)
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
                        },
                        clearItemName: choosedItem?.file ?? ""
                    )
                    .navigationBarBackButtonHidden()
                }, label: {EmptyView()})

                VStack {
                    NavPanelSearchInsideGreen(
                        searchText: $searchText,
                        filterType: $filterType,
                        searchTypeElement: .plane,
                        onCommit: {},
                        choosedFilter: { item in
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
                        }
                    )
                    .padding(.bottom, bigSize ? 30 : 0)
                    
                    if farmViewModel.filteredFarms.isEmpty {
                        Text("No result found")
                            .font(FontTurboGear.gilroyStyle(size: 24, type: .medium))
                            .foregroundColor(.white)
                            .padding(.top, 100)
                    } else {
                        VStack(spacing: bigSize ? 24 : 16) {
                            bodyMiddleSection
                                .paddingFlyBullet()
                                .frame(maxHeight: 465)
                            bottomSection
                        }
                        .ignoresSafeArea(.all)
                    }
                    
                    Spacer()
                    
                    BottomFilterBarView(
                        filterType: $filterType,
                        choosedFilter: { item in
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
                        }
                    )
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
            .onChange(of: searchText) { _ in
                farmViewModel.searchText = searchText
                farmViewModel.pressingFilterFarms()
                firstElementUpdate()
            }
            .onAppear {
                NotificationCenter.default.addObserver(
                    forName: NSNotification.Name("FarmModelChanged"),
                    object: nil,
                    queue: nil
                ) { notification in
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
                workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    
    private func firstElementUpdate() {
        if !farmViewModel.filteredFarms.isEmpty {
            choosedItem = farmViewModel.filteredFarms.first
            choosedImageName = "\(DropBoxKeys_SimulatorFarm.farmsImagePartPath)\(choosedItem?.image ?? "")"
            choosedLikeState = choosedItem?.isFavorited ?? false
            print("Updating selected item - Title: \(choosedItem?.title ?? "no title"), Description: \(choosedItem?.description ?? "no description")")
            updateId = UUID()
        } else {
            print("No farms available to display")
        }
    }
    
    private var bodyMiddleSection: some View {
        PreviewItemFromRemote(
            imageData: choosedItem?.imageData,
            imagePath: "\(DropBoxKeys_SimulatorFarm.farmsImagePartPath)\(choosedItem?.image ?? "")",
            titleData: choosedItem?.title ?? "Name",
            previewText: choosedItem?.description ?? "Description unavailable",
            likeState: $choosedLikeState,
            tappedLikeButton: { bool in
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
            },
            openDescriptionItem: {
                if choosedItem?.imageData != nil {
                    ifOpenAboutPage = true
                    openAboutPage.toggle()
                }
            },
            sendBackImageData: { sendData in
                Task {
                    await MainActor.run {
                        if let choosedItem {
                            farmViewModel.addDataToImage(data: sendData, updatedItemModel: choosedItem)
                            farmViewModel.updateFarmModel(updatedFarmModel: choosedItem)
                            farmViewModel.fetchFarmsFromCoreData()
                        }
                    }
                }
            }
        )
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


struct WallpapersPageViolent_Previews: PreviewProvider {
    static var previews: some View {
        // Create a preview container with required dependencies
        NavigationView {
            WallpapersPageViolent()
                // Inject required environment objects
                .environmentObject(NetworkManager_SimulatorFarm())
                .environmentObject(DropBoxManager_SimulatorFarm.shared)
                // Set up Core Data environment
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
        // Apply navigation view style for consistency
        .navigationViewStyle(StackNavigationViewStyle())
        // Set up preview parameters
        .previewDisplayName("Wallpapers Page")
        // Optional: Add different color schemes and device types
        .preferredColorScheme(.dark)
        // Add preview device
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
        
        // Add an iPad preview as well
        NavigationView {
            WallpapersPageViolent()
                .environmentObject(NetworkManager_SimulatorFarm())
                .environmentObject(DropBoxManager_SimulatorFarm.shared)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .previewDisplayName("Wallpapers Page - iPad")
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
    }
}
