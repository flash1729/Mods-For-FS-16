//
//  AboutEditorPage.swift
//  Farming Simulator 2022
//
//  Created by Sim on 30/09/24.
//

import SwiftUI

struct AboutEditorPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewMotel: EditorViewModel
    @Environment(\.dismiss) private var dismiss
    @State var editTapped: () -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var saveStateIphone: IconTurboGear.SaveStateIconTurbo = .saveSuccesfulIconElement
    @State var showSaveState: Bool = false
    @State var deleteAlert: Bool = false
    
    @Binding var choosedData: BodyEditor?
    
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @State var workInternetState: Bool = true
    @State var timer: Timer?
    @State var showSaveAlert: Bool = false
    var body: some View {
        ZStack{
            bodySection
            
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
            
            if showSaveAlert {
                SaveEditorAlert { state in
                    if state {
                        viewMotel.requestPhotoLibraryPermission { granted in
                            if granted {
                                if let imageData = choosedData?.fullImage, let result = UIImage(data: imageData) {
                                    UIImageWriteToSavedPhotosAlbum(result, self, nil, nil)
                                    saveStateIphone = .saveSuccesfulIconElement
                                    showSaveState = true
                                } else {
                                    saveStateIphone = .saveFailedIconElement
                                    showSaveState = true
                                }
                            } else {
                                saveStateIphone = .saveFailedIconElement
                                showSaveState = true
                            }
                        }
                        showSaveAlert = false
                    } else {
                        showSaveAlert = false
                    }
                }
            }
        }
        .onAppear(){
            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
        }
    }
    
    private var bodySection: some View {
        ZStack {
            VStack(spacing: bigSize ? 20 : 10) {
                NavPanelCyanEditors(titleName: "Editor", rightbuttonIconType: .constant(.editItem), leftbuttonIconType: .backChev, rigthButtonTapped: {
                    viewMotel.updateData = true
                    editTapped()
                    dismiss()
                })
                downloadSection
                    .paddingFlyBullet()
                RoundedRectangle(cornerRadius: bigSize ? 20 : 12)
                    .fill(ColorTurboGear.colorPicker(.darkGray))
                    .frame(maxHeight: bigSize ? 646 : 421)
                    .overlay {
                        Image(uiImage: UIImage(data: choosedData?.fullImage ?? Data()) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                    }
                    .overlay {
                        Button {
                            deleteAlert.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.red.opacity(0.74))
                                .frame(width: bigSize ? 93 : 40, height: bigSize ? 93 : 40)
                                .overlay {
                                    Image(IconTurboGear.TopNavIconTurbo.removeItemFromDB)
                                        .resizable()
                                        .scaledToFit()
                                        .padding( bigSize ? 20 : 10)
                                }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(bigSize ? 20 : 10)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.top, bigSize ? 50 : 10)
                    .paddingFlyBullet()
                Spacer()
                BlueButtonWithBorders(blueButtonTap: {
                    showSaveAlert.toggle()
                }, titleButton: "Save", infinityWidth: true)
                .paddingFlyBullet()
                .padding(.bottom, bigSize ? 50 : 10)
            }
            .ignoresSafeArea(.all, edges: .top)
            
            if deleteAlert {
                DeleteItemAlert { state in
                    if state {
                        if let choosedData {
                            viewContext.delete(choosedData)
                            try? viewContext.save()
                        }
                        dismiss()
                    } else {
                        deleteAlert.toggle()
                    }
                }
            }
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
