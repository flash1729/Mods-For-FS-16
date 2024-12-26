//
//  CreateSelfAvatarAndEditPageViolent.swift
//  Farming Simulator 2022
//
//  Created by Sim on 24/09/24.
//

import SwiftUI

struct CreateSelfAvatarAndEditPageViolent: View {
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
                NavPanelCyanEditors(titleName: "Editor", rightbuttonIconType: $typeRightIconTypeNav, rigthButtonTapped: {
                    if openEditor == false {
                        DispatchQueue.main.async {
                            openEditor.toggle()
                        }
                    } else {
                        DispatchQueue.main.async {
                            showSaveAlert.toggle()
                        }
                    }
                })
                .padding(.bottom, bigSize ? 10 : 5)
                downloadSection
                    .paddingFlyBullet()
                ZStack{
                    if openEditor {
                        EditorConfigurator(viewMotel: viewMotel, tappedButton: $showPartBodyList, choosedPartModel: $choosedPart, genderType: $genderType, fullImagePeopleToSave: $viewMotel.fullImagePeopleToSave, choosedData: $choosedData, showInternetAlert: $showInternetAlert)
                        
                    } else {
                        collectionItmesView
                    }
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
                SaveStateCustomView(saveState: $saveStateType)
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
            Text("There are currently no characters in your narrative.")
                .multilineTextAlignment(.center)
                .frame(maxHeight: .infinity)
                .foregroundColor(.white)
                .font(FontTurboGear.montserratStyle(size: bigSize ? 28 : 22, type: .semibold))
        }
    }
    
    private var collectionItmesView: some View {
        ZStack{
            
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
//                                viewMotel.requestPhotoLibraryPermission { granted in
//                                    if granted {
//                                        choosedData = item
//                                        if let imageData = choosedData?.fullImage, let result = UIImage(data: imageData) {
//                                            UIImageWriteToSavedPhotosAlbum(result, self, nil, nil)
//                                            showSaveState.toggle()
//                                            choosedData = nil
//                                        }
//                                    }
//                                }
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
        }
    }
    
    private func cellToCollection(image: Data?, completionSave: @escaping () -> Void, completionAbout: @escaping () -> Void) -> some View {
        RoundedRectangle(cornerRadius: bigSize ? 44 : 20)
            .fill(ColorTurboGear.colorPicker(.darkGray))
            .frame(height: bigSize ? 445 : 200)
            .overlay {
                Image(uiImage: UIImage(data: image ?? Data()) ?? UIImage())
                    .resizable()
                    .scaledToFit()
            }
            .onTapGesture {
                completionAbout()
            }
            .overlay(content: {
                Button {
                    completionSave()
                } label: {
                    RoundedRectangle(cornerRadius: bigSize ? 31 : 14)
                        .fill(Color.white.opacity(0.55))
                        .frame(width: bigSize ? 93 : 40, height: bigSize ? 93 : 40)
                        .overlay {
                            Image(IconTurboGear.TopNavIconTurbo.saveImageToGallary)
                                .resizable()
                                .scaledToFit()
                                .padding( bigSize ? 20 : 10)
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(bigSize ? 20 : 10)
            })
            .clipShape(RoundedRectangle(cornerRadius: bigSize ? 44 : 20))
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
