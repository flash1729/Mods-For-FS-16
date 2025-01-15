//
//  CreateSelfAvatarAndEditPageViolent.swift
//  Farming Simulator 2022
//
//  Created by Sim on 24/09/24.
//

import SwiftUI

struct AvatarCreationAndEditPageController: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BodyEditor.date, ascending: false)],
                        predicate: NSPredicate(format: "randomKey == %@", NSNumber(value: false)))
        private var allData: FetchedResults<BodyEditor>
    @State var choosedData: BodyEditor?
    @ObservedObject var viewMotel: EditorViewModel
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var typeRightIconTypeNav: IconTurboGear.TopNavIconTurbo = .createNewAvatar
    
    @State var openEditor: Bool = false
    @State var openAboutItem: Bool = false
    
    @State var choosedPart: EditorTypePartOfBody?
    @State var genderType: GenderTypeModel = .man
    @State var showPartBodyList: Bool = false
    
    @State var showSaveAlert: Bool = false
    @State var showSaveState: Bool = false
    @State var showSaveStateToGallery: Bool = false
    @State var saveStateType: IconTurboGear.SaveStateIconTurbo = .saveSuccesfulIconElement
    
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @State var showInternetAlert: Bool = false
    @State var workInternetState: Bool = true
    @State var timer: Timer?
    
    var body: some View {
        ZStack {
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
            
            if showSaveStateToGallery {
                SaveEditorAlert { state in
                    if state {
                        viewMotel.requestPhotoLibraryPermission { granted in
                            print("Granted \(granted)")
                            if granted {
                                if let imageData = choosedData?.fullImage, let result = UIImage(data: imageData) {
                                    UIImageWriteToSavedPhotosAlbum(result, self, nil, nil)
                                    saveStateType = .saveSuccesfulIconElement
                                    showSaveState = true
                                } else {
                                    saveStateType = .saveFailedIconElement
                                    showSaveState = true
                                }
                            } else {
                                saveStateType = .saveFailedIconElement
                                showSaveState = true
                            }
                        }
                        showSaveStateToGallery = false
                    } else {
                        showSaveStateToGallery = false
                    }
                }
            }
        }
        .onChange(of: openEditor) { value in
            value ? (typeRightIconTypeNav = .saveNewAvavtar) : (typeRightIconTypeNav = .createNewAvatar)
        }
        .onAppear(){
            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
            workInternetState ? (showInternetAlert = false) : (showInternetAlert = true)
        }
    }
    
    private var bodySection: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            NavigationLink(isActive: $openAboutItem, destination: {
                AboutEditorPage(viewMotel: viewMotel, editTapped: {
                    openEditor.toggle()
                }, choosedData: $choosedData)
                .navigationBarBackButtonHidden()
                .onDisappear(){
                    if openEditor == false {
                        choosedData = nil
                    }
                }
            }, label: { EmptyView() })
            VStack(spacing: bigSize ? 31 : 10) {
                EditorNavBar(
                    isEditing: openEditor,
                    viewMotel: viewMotel,
                    showSaveState: $showSaveState,
                    saveStateType: $saveStateType
                )
                .padding(.bottom, bigSize ? 10 : 5)
                downloadSection
                    .paddingFlyBullet()
                ZStack{
                    if openEditor {
                        AvatarEditorConfiguratorController(viewMotel: viewMotel, tappedButton: $showPartBodyList, choosedPartModel: $choosedPart, genderType: $genderType, fullImagePeopleToSave: $viewMotel.fullImagePeopleToSave, choosedData: $choosedData, showInternetAlert: $showInternetAlert)
                        
                    } else {
                        collectionItmesView
                    }
                }
                
    
            }
            .ignoresSafeArea(.all, edges: .top)
            .frame(maxHeight: .infinity, alignment: .top)
            
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
                        Task {
                            await saveStateToCoreData()
                        }
                    } else {
                        showSaveAlert.toggle()
                        openEditor = false
                        choosedData = nil
                        
                        workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
                        workInternetState ? (showInternetAlert = false) : (showInternetAlert = true)
                    }
                }, saveToHisory: true)
            }
        }
    }
    
    private var downloadSection: some View {
        VStack {
            if showSaveState {
                SaveConfirmationAlertView(saveState: $saveStateType)
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            self.showSaveState = false
                        })
                    }
            }
        }
    }
    
    private var emptyViewText: some View {
        VStack {
            Text("Nothing was found here, let’s create new")
                .multilineTextAlignment(.center)
                .frame(maxHeight: .infinity)
                .foregroundColor(.white)
                .font(FontTurboGear.gilroyStyle(size: bigSize ? 28 : 22, type: .semibold))
        }
    }
    
    private var collectionItmesView: some View {
        ZStack {
            VStack {
                if allData.isEmpty {
                    emptyViewText
                        .paddingFlyBullet()
                } else {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: bigSize ? 30 : 10), GridItem(.flexible(), spacing: bigSize ? 30 : 10)], spacing: bigSize ? 30 : 10) {
                            ForEach(allData, id: \.idPeople) { item in
                                cellToCollection(image: item.smallPreviewImage, completionSave: {
                                    choosedData = item
                                    showSaveStateToGallery.toggle()
                                }, completionAbout: {
                                    choosedData = item
                                    openAboutItem.toggle()
                                })
                            }
                        }
                        .padding(.top, bigSize ? 30 : 10)
                    }
                    .paddingFlyBullet()
                }

                Spacer()

                // Add new bottom button section
                VStack {
                    GreenButtonWithBorders(
                        title: "Create new +",
                        action: {
                            // Reset editor state
                            viewMotel.tempManPeople = nil
                            viewMotel.tempWomanPeople = nil
                            viewMotel.updateData = false
                            viewMotel.sandvichPeople.allNil()
                            
                            // Open editor
                            openEditor = true
                            choosedPart = .body
                            genderType = .man
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
    }
    
    private func cellToCollection(image: Data?, completionSave: @escaping () -> Void, completionAbout: @escaping () -> Void) -> some View {
        VStack(spacing: 12) {
            // Image Container
            RoundedRectangle(cornerRadius: bigSize ? 24 : 16)
                .frame(width: bigSize ? 148 : 148, height: bigSize ? 380 : 130)
                .overlay {
                    if let imageData = image, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        // Loading indicator
                        Image(systemName: "arrow.2.circlepath")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .rotationEffect(.degrees(360))
                            .animation(
                                Animation.linear(duration: 1)
                                    .repeatForever(autoreverses: false),
                                value: true
                            )
                    }
                }
                .onTapGesture {
                    completionAbout()
                }
                .clipShape(RoundedRectangle(cornerRadius: bigSize ? 24 : 16))
            
            // Upload Button
            Button(action: completionSave) {
                HStack(spacing: 8) {
                    Text("Upload")
                        .font(FontTurboGear.gilroyStyle(
                            size: bigSize ? 18 : 14,
                            type: .semibold
                        ))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: bigSize ? 44 : 36)
                .background(
                    RoundedRectangle(cornerRadius: bigSize ? 16 : 12)
                        .fill(ColorTurboGear.colorPicker(.darkGreen))
                )
                .clipShape(RoundedRectangle(cornerRadius: bigSize ? 28 : 16))
            }
            .padding(.horizontal, bigSize ? 16 : 12)
        }
        .clipShape(RoundedRectangle(cornerRadius: bigSize ? 28 : 20))
    }
    
    private func saveStateToCoreData() async {
        if viewMotel.updateData {
            if let choosedData {
                viewMotel.updateItemToCoreData(updateItem: choosedData, item: viewMotel.sandvichPeople, viewContext: viewContext, genderType: genderType, randomType: false, saveComplete: {state in
                    if state {
                        saveStateType = .saveSuccesfulIconElement
                    } else {
                        saveStateType = .saveFailedIconElement
                    }
                    viewMotel.sandvichPeople.allNil()
                    openEditor.toggle()
                    self.choosedData = nil
                })
            }
            viewMotel.updateData = false
        } else {
            print("save new item, sandvich \(viewMotel.sandvichPeople)")
            viewMotel.saveItemToCoreData(item: viewMotel.sandvichPeople, viewContext: viewContext, genderType: genderType, randomType: false, saveComplete: {state in
                if state {
                    saveStateType = .saveSuccesfulIconElement
                } else {
                    saveStateType = .saveFailedIconElement
                }
                viewMotel.sandvichPeople.allNil()
                openEditor.toggle()
                self.choosedData = nil
            })
        }
        
        showSaveAlert.toggle()
        openEditor = false
        choosedData = nil
        
    }
}
