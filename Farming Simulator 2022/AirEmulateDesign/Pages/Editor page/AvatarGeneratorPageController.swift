//
//  AvatarRandomPageViolent.swift
//  Farming Simulator 2022
//
//  Created by Sim on 24/09/24.
//

import SwiftUI

struct AvatarGeneratorPageController: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BodyElement.idElement, ascending: false)])
        private var allElementData: FetchedResults<BodyElement>
    @ObservedObject var viewMotel: EditorViewModel
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var typeRightIconTypeNav: IconTurboGear.TopNavIconTurbo = .createAvatarRandom
    @State var showPreview: Bool = false
    
    @State var choosedPart: EditorTypePartOfBody?
    @State var showPartBodyList: Bool = false
    
    @State var showEditConfigurator: Bool = false
    @State var genderType: GenderTypeModel = .man
    @State var choosedData: BodyEditor?
    @State var showSaveAlert: Bool = false
    
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @State var showInternetAlert: Bool = false
    @State var workInternetState: Bool = true
    @State var timer: Timer?
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            
            bodySection
            
            if !workInternetState {
                LostConnectElement {
                    workInternetState.toggle()
                    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                        if workInternetState {
                            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
                            showInternetAlert = true
                        }
                    }
                }
            }
        }
        .onAppear(){
            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
            workInternetState ? (showInternetAlert = false) : (showInternetAlert = true)
        }
    }
    
    private var bodySection: some View {
        ZStack {

            VStack(spacing: bigSize ? 31 : 10) {
                // Replace NavPanelCyanEditors with NavPanelGreenWithoutFavButton
                AvatarGenNavBar(
                    isGenerating: showPreview,
                    viewMotel: viewMotel,
                    genderType: genderType,
                    showEditConfigurator: $showEditConfigurator,
                    choosedData: $choosedData
                )
                .padding(.bottom, bigSize ? 10 : 5)
                
                // Main content area
                if showPreview {
                    AvatarPreviewController(
                        viewMotel: viewMotel,
                        choosedPart: $choosedPart,
                        showPartBodyList: $showPartBodyList,
                        showEditConfigurator: $showEditConfigurator,
                        genderType: $genderType,
                        choosedData: $choosedData,
                        smallImagePeopleToSave: $viewMotel.smallImagePeopleToSave,
                        showInternetAlert: $showInternetAlert
                    )
                } else {
                    previewTextSection
                        .paddingFlyBullet()
                }
                
//                Spacer() // Push content to top and button to bottom
                
                if !showEditConfigurator {
                    VStack {
                        GreenButtonWithBorders(
                            title: "Generate new +",
                            action: {
                                randomAvater()
                                
                                if !showPreview {
                                    showPreview = true
                                } else if typeRightIconTypeNav == .saveNewAvavtar {
                                    showSaveAlert.toggle()
                                }
                            }
                        )
                        .paddingFlyBullet()
                        .padding(.top, bigSize ? 30 : 15)
                        .padding(.bottom, bigSize ? 50 : 25)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        ColorTurboGear.colorPicker(.green)
                            .cornerRadius(20, corners: [.topLeft, .topRight])
                            .edgesIgnoringSafeArea(.bottom)
                    )
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            
//            if showPartBodyList {
//                ZStack {
//                    Color.black.opacity(0.5)
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            showPartBodyList.toggle()
//                        }
//                    AllEditorButtons(tappeedButton: $choosedPart, dismissLayer: $showPartBodyList, selectedGender: {type in
//                        switch type {
//                        case .man:
//                            genderType = .man
//                            viewMotel.changeGenderInButton.toggle()
//                        case .woman:
//                            genderType = .woman
//                            viewMotel.changeGenderInButton.toggle()
//                        }
//                    })
//                }
//                .transition(.opacity)
//                .zIndex(1)
//            }
            
//            if showPartBodyList {
//                ZStack {
//                    Color.black.opacity(0.5)
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            showPartBodyList.toggle()
//                        }
//                    GenderSelector(dismissLayer: $showPartBodyList) { type in
//                        switch type {
//                        case .man:
//                            genderType = .man
//                            viewMotel.changeGenderInButton.toggle()
//                        case .woman:
//                            genderType = .woman
//                            viewMotel.changeGenderInButton.toggle()
//                        }
//                    }
//                }
//                .transition(.opacity)
//                .zIndex(1)
//            }
            
            if showSaveAlert {
                SaveEditorAlert(stateTapped: {state in
                    if state {
                        viewMotel.randomItem = viewMotel.sandvichPeople
                        if let choosedData{
                            viewMotel.updateWithoutSaveItemTCoreData(updateItem: choosedData, item: viewMotel.sandvichPeople, genderType: genderType, randomType: true)
                            try? viewContext.save()
                        }
                        showSaveAlert.toggle()
                        showEditConfigurator.toggle()
                        print("Save random avatar")
                    } else {
                        
                        viewContext.reset()
                        choosedData = BodyEditor(context: viewContext)
                        if let choosedData {
                            viewMotel.updateWithoutSaveItemTCoreData(updateItem: choosedData, item: viewMotel.randomItem, genderType: genderType, randomType: true)
                            let _ = viewMotel.mergeImages(from: viewMotel.randomItem.sendAllImages())
                            viewContext.delete(choosedData)
                        }
                        showSaveAlert.toggle()
                        showEditConfigurator.toggle()
                        print("Cancel random avatar")
                    }
                }, saveToHisory: true)
            }
        }
        .onChange(of: showEditConfigurator) { newValue in
            if showEditConfigurator {
                typeRightIconTypeNav = .saveNewAvavtar
            } else {
                typeRightIconTypeNav = .createAvatarRandom
            }
        }
    }
    
    private var previewTextSection: some View {
        VStack {
            Text("Press the button below to create a new avatar")
                .multilineTextAlignment(.center)
                .font(FontTurboGear.gilroyStyle(size: bigSize ? 28 : 14, type: .regular))
                .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
        }
        .padding(.top, bigSize ? 199 : 44)
        .frame(maxHeight: .infinity, alignment: .center)
    }
    
    private func randomAvater() {
        genderType = GenderTypeModel(rawValue: Int16.random(in: 0..<2)) ?? .man
        viewMotel.randomItem = viewMotel.randomAvaterConfiguration(genderType: genderType, allData: allElementData)
        let _ = viewMotel.mergeImages(from: viewMotel.randomItem.sendAllImages())
    }
}

struct AvatarRandomPageViolent_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // iPhone Preview
            NavigationView {
                AvatarGeneratorPageController(viewMotel: EditorViewModel())
                    // Inject required environment objects
                    .environmentObject(NetworkManager_SimulatorFarm())
                    .environmentObject(DropBoxManagerModel_SimulatorFarm.shared)
                    // Set up Core Data environment
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .previewDisplayName("Avatar Generator - iPhone")
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            
            // iPad Preview
            NavigationView {
                AvatarGeneratorPageController(viewMotel: EditorViewModel())
                    .environmentObject(NetworkManager_SimulatorFarm())
                    .environmentObject(DropBoxManagerModel_SimulatorFarm.shared)
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .previewDisplayName("Avatar Generator - iPad")
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
        }
    }
}
