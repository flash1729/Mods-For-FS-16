//
//  MenuListToApp.swift
//  Farming Simulator 2022
//
//  Created by Sim on 24/09/24.
//

import SwiftUI

struct MenuListToApp: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dropBoxManager: DropBoxManager_SimulatorFarm
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BodyElement.idElement, ascending: false)])
        private var allData: FetchedResults<BodyElement>
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @ObservedObject var crotel: LoadingPreviewVMCyan = LoadingPreviewVMCyan()
    @State var itemTypeChoosed: IconTurboGear.MenuIconTurbo?
    @State var openPage: Bool = false
    
    @State var workInternetState: Bool = true
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @State var timer: Timer?
    @State var showDownloadView: Bool = false
    @ObservedObject var viewMotel: EditorViewModel = EditorViewModel()
    var body: some View {
        NavigationView {
            ZStack{
                allLinks
                Rectangle()
                    .fill(Color.clear)
                    .overlay {
                        Image(bigSize ? IconTurboGear.superBigBackToPad : IconTurboGear.mediumRareBackToPhone)
                            .resizable()
                            .scaledToFill()
                    }
                    .ignoresSafeArea()
                if showDownloadView {
                    LoadingLoaderCustomElement(progressTimer: $crotel.progress)
                        .frame(maxHeight: .infinity, alignment: .center)
                        .onAppear(){
                            crotel.progress = 0
                        }
                        .onChange(of: crotel.progress) { newValue in
                            if newValue >= 100 {
                                DispatchQueue.main.async {
                                    openPage.toggle()
                                    withAnimation {
                                        showDownloadView.toggle()
                                    }
                                    timer?.invalidate()
                                }
                            }
                        }
                        .onAppear(){
                            Task {
                                await crotel.addAllElementToCoreData(allData: allData, dropBoxManager: dropBoxManager, viewContext: viewContext)
                            }
                        }
                } else {
                    listOfButtons
                        .frame(maxHeight: .infinity)
                        .paddingFlyBullet()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 2), value: showDownloadView)
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
    }
    private var allLinks: some View {
        VStack {
            NavigationLink(isActive: $openPage, destination: {
                switch itemTypeChoosed {
                case .dads:
                    MotorsPageViolent()
                        .navigationBarBackButtonHidden()
                case .maps:
                    MapsPageViolent()
                        .navigationBarBackButtonHidden()
                case .plane:
                    WallpapersPageViolent()
                        .navigationBarBackButtonHidden()
                case .angar:
                    AngarsPageViolent()
                        .navigationBarBackButtonHidden()
                case .nickGen:
                    NickRandomPageViolent()
                        .navigationBarBackButtonHidden()
                case .avaGen:
                    AvatarRandomPageViolent(viewMotel: viewMotel)
                        .navigationBarBackButtonHidden()
                case .editor:
                    CreateSelfAvatarAndEditPageViolent(viewMotel: viewMotel)
                        .navigationBarBackButtonHidden()
                case nil:
                    MotorsPageViolent()
                        .navigationBarBackButtonHidden()
                }
            }, label: {EmptyView()})
        }
    }
    private var listOfButtons: some View {
        VStack(spacing: 20) {
            MuneBoardForMainPage(iconType: .dads, choosedItem: $itemTypeChoosed, openPage: $openPage)
            MuneBoardForMainPage(iconType: .maps, choosedItem: $itemTypeChoosed, openPage: $openPage)
            MuneBoardForMainPage(iconType: .plane, choosedItem: $itemTypeChoosed, openPage: $openPage)
            MuneBoardForMainPage(iconType: .angar, choosedItem: $itemTypeChoosed, openPage: $openPage)
            MuneBoardForMainPage(iconType: .nickGen, choosedItem: $itemTypeChoosed, openPage: $openPage)
            MuneBoardForMainPage(iconType: .avaGen, choosedItem: $itemTypeChoosed, openPage: $showDownloadView)
            MuneBoardForMainPage(iconType: .editor, choosedItem: $itemTypeChoosed, openPage: $showDownloadView)
        }
    }
}

#Preview {
    MenuListToApp()
}
