//
//  RandomHistoryPage.swift
//  Farming Simulator 2022
//
//  Created by Sim on 01/10/24.
//

import SwiftUI

struct RandomHistoryPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BodyEditor.date, ascending: false)],
                        predicate: NSPredicate(format: "randomKey == %@", NSNumber(value: true)))
        private var allData: FetchedResults<BodyEditor>
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewMotel: EditorViewModel
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var choosedToEditCompletion: () -> Void
    @State var deleteAlert: Bool = false
    @Binding var choosedData: BodyEditor?
    @State var showSaveAlert: Bool = false
    @State var showSaveState: Bool = false
    @State var saveStateIphone: IconTurboGear.SaveStateIconTurbo = .saveSuccesfulIconElement
    
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @State var workInternetState: Bool = true
    @State var timer: Timer?
    var body: some View {
        ZStack {
            bodySectionMain
            
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
    }
    
    private var bodySectionMain: some View {
        ZStack {
            VStack(spacing: bigSize ? 31 : 10) {
                NavPanelCyanWithoutFavButton(titleName: "History")
                .padding(.bottom, bigSize ? 10 : 5)
                downloadSection
                    .paddingFlyBullet()
                bodySection
                    .frame(maxHeight: .infinity)
                    .paddingFlyBullet()
            }
            .ignoresSafeArea(.all, edges: .top)
            .frame(maxHeight: .infinity, alignment: .top)
            
            if deleteAlert {
                DeleteItemAlert { state in
                    if state {
                        if let choosedData{
                            viewContext.delete(choosedData)
                            try? viewContext.save()
                            DispatchQueue.main.async {
                                deleteAlert.toggle()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            deleteAlert.toggle()
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
    }
    
    private var bodySection: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: bigSize ? 30 : 10), GridItem(.flexible(), spacing: bigSize ? 30 : 10)], spacing: bigSize ? 30 : 10) {
                ForEach(allData, id: \.idPeople) { item in
                    cellToCollection(item: item)
                }
            }
            .padding(.top, bigSize ? 30 : 10)
        }
    }
    
    private func cellToCollection(item: BodyEditor) -> some View {
        RoundedRectangle(cornerRadius: bigSize ? 44 : 20)
            .fill(ColorTurboGear.colorPicker(.darkGray))
            .frame(height: bigSize ? 445 : 200)
            .overlay {
                ZStack {
                    if let imageData = item.smallPreviewImage, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            .overlay(content: {
                HStack {
                    buttonCustom(tapped: {
                        choosedData = item
                        DispatchQueue.main.async {
                            deleteAlert.toggle()
                        }
                    }, iconType: .removeItem, redColor: true)
                    
                    buttonCustom(tapped: {
                        choosedData = item
                        choosedToEditCompletion()
                        dismiss()
                    }, iconType: .editItem)
                    
                    buttonCustom(tapped: {
                        choosedData = item
                        showSaveAlert = true
                    }, iconType: .saveImage)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(bigSize ? 20 : 10)

            })
            .clipShape(RoundedRectangle(cornerRadius: bigSize ? 44 : 20))
    }
    
    private func buttonCustom(tapped: @escaping () -> Void, iconType: IconTurboGear.TopNavIconTurbo, redColor: Bool = false) -> some View {
        Button {
            tapped()
        } label: {
            RoundedRectangle(cornerRadius: bigSize ? 31 : 14)
                .fill(redColor ? Color.red.opacity(0.74) : Color.white.opacity(0.55))
                .frame(width: bigSize ? 93 : 40, height: bigSize ? 93 : 40)
                .overlay {
                    Image(iconType.sendNameOfIcon())
                        .resizable()
                        .scaledToFit()
                        .padding( bigSize ? 20 : 10)
                }
        }
        .frame(maxWidth: .infinity)
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
