//
//  AvatarRandomPageViolent.swift
//  Farming Simulator 2022
//
//  Created by Sim on 24/09/24.
//

import SwiftUI

struct AvatarRandomPageViolent: View {
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
                NavPanelCyanEditors(titleName: "Avatar gen", rightbuttonIconType: $typeRightIconTypeNav, rigthButtonTapped: {
                    if typeRightIconTypeNav == .createAvatarRandom {
                        randomAvater()
                        showPreview = true
                    }
                    if typeRightIconTypeNav == .saveNewAvavtar {
                        showSaveAlert.toggle()
                    }
                })
                .padding(.bottom, bigSize ? 10 : 5)
                if showPreview {
                    RandomPreviewAvatar(viewMotel: viewMotel, choosedPart: $choosedPart, showPartBodyList: $showPartBodyList, showEditConfigurator: $showEditConfigurator, genderType: $genderType, choosedData: $choosedData, smallImagePeopleToSave: $viewMotel.smallImagePeopleToSave, showInternetAlert: $showInternetAlert)
                } else {
                    previewTextSection
                        .paddingFlyBullet()
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            .frame(maxHeight: .infinity, alignment: .top)
            
            if showPartBodyList {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showPartBodyList.toggle()
                        }
                    AllEditorButtons(tappeedButton: $choosedPart, dismissLayer: $showPartBodyList, selectedGender: {type in
                        switch type {
                        case .man:
                            genderType = .man
                            viewMotel.changeGenderInButton.toggle()
                        case .woman:
                            genderType = .woman
                            viewMotel.changeGenderInButton.toggle()
                        }
                    })
                }
                .transition(.opacity)
                .zIndex(1)
            }
            
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
            Image(IconTurboGear.generateNewAvatar)
                .resizable()
                .scaledToFit()
                .frame(height: bigSize ? 172 : 70)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            Text("Generate your new avatar")
                .multilineTextAlignment(.center)
                .font(FontTurboGear.montserratStyle(size: bigSize ? 28 : 22, type: .semibold))
                .foregroundColor(.white)
        }
        .padding(.top, bigSize ? 199 : 44)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private func randomAvater() {
        genderType = GenderTypeModel(rawValue: Int16.random(in: 0..<2)) ?? .man
        viewMotel.randomItem = viewMotel.randomAvaterConfiguration(genderType: genderType, allData: allElementData)
        let _ = viewMotel.mergeImages(from: viewMotel.randomItem.sendAllImages())
    }
}
