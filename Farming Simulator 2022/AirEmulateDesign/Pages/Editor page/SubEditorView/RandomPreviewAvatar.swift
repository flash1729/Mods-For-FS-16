//
//  RandomPreviewAvatar.swift
//  Farming Simulator 2022
//
//  Created by Sim on 01/10/24.
//

import SwiftUI

struct RandomPreviewAvatar: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewMotel: EditorViewModel
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var saveStateIphone: IconTurboGear.SaveStateIconTurbo = .saveSuccesfulIconElement
    @State var showSaveState: Bool = false
    @State var showDownloadProgress: Bool = true
    @State var progressDownload: Double = 0.0
    @Binding var choosedPart: EditorTypePartOfBody?
    @Binding var showPartBodyList: Bool
    
    @Binding var showEditConfigurator: Bool
    @State var showHistory: Bool = false
    @Binding var genderType: GenderTypeModel
    @Binding var choosedData: BodyEditor?
    @State var updateId: UUID = UUID()
    @Binding var smallImagePeopleToSave: UIImage?
    @Binding var showInternetAlert: Bool
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @State var workInternetState: Bool = true
    var body: some View {
        ZStack {
            NavigationLink(isActive: $showHistory, destination: {
                RandomHistoryPage(viewMotel: viewMotel, choosedToEditCompletion: {
                    showEditConfigurator.toggle()
                }, choosedData: $choosedData)
                    .navigationBarBackButtonHidden()
            }, label: {EmptyView()})
            if showEditConfigurator {
                EditorConfigurator(viewMotel: viewMotel, tappedButton: $showPartBodyList, choosedPartModel: $choosedPart, genderType: $genderType, fullImagePeopleToSave: $viewMotel.fullImagePeopleToSave, choosedData: $choosedData, showInternetAlert: $showInternetAlert)
            } else {
                previewSection
            }
        }
        .onChange(of: viewMotel.updateDataSecond) { newValue in
            updateId = UUID()
            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
            workInternetState ? (showInternetAlert = false) : (showInternetAlert = true)
        }
        .onAppear(){
            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
            workInternetState ? (showInternetAlert = false) : (showInternetAlert = true)
        }
    }
    
    private var previewSection: some View {
        ZStack {
            VStack(spacing: bigSize ? 30 : 15) {
                downloadSection
                imageSection
                buttonsSection
                    .padding(.bottom, bigSize ? 50 : 10)
                    .frame(maxWidth: bigSize ? (UIScreen.main.bounds.width * 0.6) : .infinity)
            }
            .paddingFlyBullet()
        }
    }
    
    private var imageSection: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(ColorTurboGear.colorPicker(.darkGray))
            .overlay {
                ZStack {
                    if let image = smallImagePeopleToSave {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        InfinityLoaderCyan()
                            .frame(height: 55)
                    }
                }
                .id(updateId)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
    }
    
    private var buttonsSection: some View {
        VStack(spacing: bigSize ? 34 : 10) {
            HStack {
                customButtonRandomAvatar(title: "Edit", tapped: {
                    choosedData = BodyEditor(context: viewContext)
                    if let choosedData{
                        choosedData.idPeople = UUID()
                        viewMotel.updateWithoutSaveItemTCoreData(updateItem: choosedData, item: viewMotel.randomItem, genderType: genderType, randomType: true)
                        showEditConfigurator.toggle()
                    }
                })
                customButtonRandomAvatar(title: "History", border: true, tapped: {
                    DispatchQueue.main.async {
                        showHistory.toggle()
                    }
                })
            }
            customButtonRandomAvatar(title: "Download", tapped: {
                viewMotel.saveItemToCoreData(item: viewMotel.randomItem, viewContext: viewContext, genderType: genderType, randomType: true, saveComplete: {state in
                    if state {
                        saveStateIphone = .saveSuccesfulIconElement
                        showSaveState = true
                    } else {
                        saveStateIphone = .saveFailedIconElement
                        showSaveState = true
                    }
                })
            })
        }
        .padding(.top, bigSize ? 20 : 0)
    }
    
    private func customButtonRandomAvatar(title: String, border: Bool = false, tapped: @escaping () -> Void) -> some View {
        Button {
            tapped()
        } label: {
            Text(title)
                .frame(height: bigSize ? 100 : 56)
                .frame(maxWidth: .infinity)
                .background( border ? ColorTurboGear.colorPicker(.darkGray) : ColorTurboGear.colorPicker(.cyan))
                .overlay(content: {
                    ZStack {
                        if border {
                            RoundedRectangle(cornerRadius: bigSize ? 30 : 16)
                                .strokeBorder(ColorTurboGear.colorPicker(.cyan), lineWidth: 3, antialiased: true)
                        }
                    }
                })
                .clipShape(RoundedRectangle(cornerRadius: bigSize ? 30 : 16))
                .font(FontTurboGear.montserratStyle(size: bigSize ? 34 : 18, type: .semibold))
                .foregroundColor(.white)
        }
    }
    
    private var downloadSection: some View {
        VStack {
            if showSaveState {
                SaveStateCustomView(saveState: $saveStateIphone)
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            self.showSaveState = false
                        })
                    }
            }
        }
    }
}
