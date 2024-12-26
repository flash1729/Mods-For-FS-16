//
//  EditorConfigurator.swift
//  Farming Simulator 2022
//
//  Created by Sim on 01/10/24.
//

import SwiftUI

struct EditorConfigurator: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dropBoxManager: DropBoxManager_SimulatorFarm
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BodyElement.idElement, ascending: false)])
        private var allElementData: FetchedResults<BodyElement>
    @ObservedObject var viewMotel: EditorViewModel
    @State var imageData: Data? = nil
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var choosedPart: String = "0"
    @State var changeIndex: Int = 0
    @State private var scrollProxy: ScrollViewProxy? = nil
    @State var choodedTitle: String = "Gender"
    @Binding var tappedButton: Bool
    @Binding var choosedPartModel: EditorTypePartOfBody?
    @Binding var genderType: GenderTypeModel
    @State var arrayOfSandvichImages: [UIImage] = []
    @Binding var fullImagePeopleToSave: UIImage?
    @Binding var choosedData: BodyEditor?
    
    @Binding var showInternetAlert: Bool
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @State var workInternetState: Bool = true
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: bigSize ? 20 : 12)
                .fill(ColorTurboGear.colorPicker(.darkGray))
                .overlay {
                    ZStack {
                        if let mergetImage = fullImagePeopleToSave {
                            Image(uiImage: mergetImage)
                                .resizable()
                                .scaledToFit()
                        } else {
                            ColorTurboGear.colorPicker(.darkGray)
                            InfinityLoaderCyan()
                                .frame(height: 55)
                        }
                    }
                }
                .overlay {
                    nextAndPreviesButtons
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top, bigSize ? 50 : 10)
                .paddingFlyBullet()
            parstOfChoosedElement
            BlueButtonEditorWithBorder(blueButtonTap: {
                withAnimation {
                    tappedButton.toggle()
                }
            }, titleButton: $choodedTitle, infinityWidth: true)
            .paddingFlyBullet()
            .padding(.bottom, bigSize ? 50 : 10)
        }
        .ignoresSafeArea(.all, edges: .top)
        .onChange(of: choosedPartModel) { newValue in
            changeIndex = 0
            if choosedPartModel == .body {
                switch genderType {
                case .man:
                    choodedTitle = "Man".capitalized
                case .woman:
                    choodedTitle = "Woman".capitalized
                }
            } else {
                choodedTitle = choosedPartModel?.stringValue().capitalized ?? ""
            }
            if choosedData != nil {
                changeIndex = viewMotel.changeIndexInElementScroll(choosedPartModel: choosedPartModel, genderType: genderType, allData: allElementData)
            }
        }
        .onAppear(){
            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
            workInternetState ? (showInternetAlert = false) : (showInternetAlert = true)
            viewMotel.tempManPeople = nil
            viewMotel.tempWomanPeople = nil
            choosedPartModel = .body
            Task {
                await startConfigurateItem()
            }
        }
        .onChange(of: arrayOfSandvichImages) { newValue in
            let _ = viewMotel.mergeImages(from: arrayOfSandvichImages)
            fullImagePeopleToSave = viewMotel.smallImagePeopleToSave
        }
        .onChange(of: viewMotel.changeGenderInButton) { newValue in
            changeGenderType()
        }
        .onChange(of: choosedPart, perform: { value in
            DispatchQueue.main.async {
                setImageToSandvich(type: $choosedPartModel)
            }
            
        })
        .onChange(of: changeIndex, perform: { newValue in
            withAnimation {
                scrollProxy?.scrollTo(changeIndex, anchor: .center)
            }
        })
    }
    
    private func startConfigurateItem() async {
        if let choosedData{
            viewMotel.sandvichPeople.allNil()
            if GenderTypeModel(rawValue: choosedData.gender) == .man {
                genderType = .man
                viewMotel.tempManPeople?.allNil()
                viewMotel.tempManPeople?.setNameImages(coreItem: choosedData)
                viewMotel.sandvichPeople.setNameImages(coreItem: choosedData)
                viewMotel.setImageToSandvich(type: .accessories, choosedPart: choosedData.accessories ?? "", choosedPartModel: .accessories, genderType: .man, allData: allElementData)
                viewMotel.setImageToSandvich(type: .body, choosedPart: choosedData.body ?? "", choosedPartModel: .body, genderType: .man, allData: allElementData)
                viewMotel.setImageToSandvich(type: .trousers, choosedPart: choosedData.bottom ?? "", choosedPartModel: .trousers, genderType: .man, allData: allElementData)
                viewMotel.setImageToSandvich(type: .top, choosedPart: choosedData.top ?? "", choosedPartModel: .top, genderType: .man, allData: allElementData)
                viewMotel.setImageToSandvich(type: .hair, choosedPart: choosedData.hair ?? "", choosedPartModel: .hair, genderType: .man, allData: allElementData)
                viewMotel.setImageToSandvich(type: .shoes, choosedPart: choosedData.shoes ?? "", choosedPartModel: .shoes, genderType: .man, allData: allElementData)
                choodedTitle = "Man".capitalized
                let filterElement = viewMotel.filterElements(type: .body, genderType: .man, allData: allElementData)
                let findIndex = filterElement.firstIndex(where: {$0.previewImageString == choosedData.body})
                changeIndex = findIndex ?? 0
            } else {
                genderType = .woman
                viewMotel.tempWomanPeople?.allNil()
                viewMotel.tempWomanPeople?.setNameImages(coreItem: choosedData)
                viewMotel.sandvichPeople.setNameImages(coreItem: choosedData)
                viewMotel.setImageToSandvich(type: .accessories, choosedPart: choosedData.accessories ?? "", choosedPartModel: .accessories, genderType: .woman, allData: allElementData)
                viewMotel.setImageToSandvich(type: .body, choosedPart: choosedData.body ?? "", choosedPartModel: .body, genderType: .woman, allData: allElementData)
                viewMotel.setImageToSandvich(type: .trousers, choosedPart: choosedData.bottom ?? "", choosedPartModel: .trousers, genderType: .woman, allData: allElementData)
                viewMotel.setImageToSandvich(type: .top, choosedPart: choosedData.top ?? "", choosedPartModel: .top, genderType: .woman, allData: allElementData)
                viewMotel.setImageToSandvich(type: .hair, choosedPart: choosedData.hair ?? "", choosedPartModel: .hair, genderType: .woman, allData: allElementData)
                viewMotel.setImageToSandvich(type: .shoes, choosedPart: choosedData.shoes ?? "", choosedPartModel: .shoes, genderType: .woman, allData: allElementData)
                choodedTitle = "Woman".capitalized
                let filterElement = viewMotel.filterElements(type: .body, genderType: .woman, allData: allElementData)
                let findIndex = filterElement.firstIndex(where: {$0.previewImageString == choosedData.body})
                changeIndex = findIndex ?? 0
            }
            arrayOfSandvichImages = viewMotel.sandvichPeople.sendAllImages()
        } else {
            viewMotel.updateData = false
            viewMotel.sandvichPeople.allNil()
            switch genderType {
            case .man:
                let tempItem = SandvichItemType(image: UIImage(data: allElementData.filter({$0.genderType == GenderTypeModel.man.rawValue}).first(where: {$0.typeOfPart == EditorTypePartOfBody.body.rawValue})?.editroImage ?? Data()), imageName: allElementData.filter({$0.genderType == GenderTypeModel.man.rawValue}).first(where: {$0.typeOfPart == EditorTypePartOfBody.body.rawValue})?.previewImageString ?? "", zindex: 0)
                viewMotel.sandvichPeople.body = tempItem
                choodedTitle = "Man".capitalized
            case .woman:
                let tempItem = SandvichItemType(image: UIImage(data: allElementData.filter({$0.genderType == GenderTypeModel.woman.rawValue}).first(where: {$0.typeOfPart == EditorTypePartOfBody.body.rawValue})?.editroImage ?? Data()), imageName: allElementData.filter({$0.genderType == GenderTypeModel.woman.rawValue}).first(where: {$0.typeOfPart == EditorTypePartOfBody.body.rawValue})?.previewImageString ?? "", zindex: 0)
                viewMotel.sandvichPeople.body = tempItem
                choodedTitle = "Woman".capitalized
            }
            arrayOfSandvichImages = viewMotel.sandvichPeople.sendAllImages()
            changeIndex = 0
        }
        let _ = viewMotel.mergeImages(from: arrayOfSandvichImages)
        fullImagePeopleToSave = viewMotel.smallImagePeopleToSave
    }
    
    private var nextAndPreviesButtons: some View {
        HStack {
            Button {
                if changeIndex > 0 {
                    changeIndex -= 1
                }
            } label: {
                RoundedRectangle(cornerRadius:  bigSize ? 27 : 14)
                    .fill(Color.white.opacity(0.55))
                    .frame(width: bigSize ? 88 : 44, height: bigSize ? 88 : 44)
                    .overlay {
                        Image(IconTurboGear.TopNavIconTurbo.chevronLeftButtonCustom)
                            .resizable()
                            .scaledToFit()
                            .padding(bigSize ? 20 : 10)
                    }
            }
            Spacer()
            Button {
                if changeIndex < filterElements(type: $choosedPartModel, genderType: $genderType).count {
                    changeIndex += 1
                }
            } label: {
                RoundedRectangle(cornerRadius: bigSize ? 27 : 14)
                    .fill(Color.white.opacity(0.55))
                    .frame(width: bigSize ? 88 : 44, height: bigSize ? 88 : 44)
                    .overlay {
                        Image(IconTurboGear.TopNavIconTurbo.chevronLeftButtonCustom)
                            .resizable()
                            .scaledToFit()
                            .padding(bigSize ? 20 : 10)
                            .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
                    }
            }
        }
        .padding(bigSize ? 20 : 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    
    private var parstOfChoosedElement: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack {
                    if choosedPartModel != .body {
                        ElementCellForEditor(imageName: "", choosedImageName: $choosedPart, tappedOnImage: {
                            changeIndex = -1
                            setImageToSandvich(type: $choosedPartModel, removeImage: true)
                        }, sendBackImageData: {_ in
                        }, index: -1, choosedIndex: $changeIndex, onlyWhiteElement: true, showInternetAlert: $showInternetAlert)
                        .id(changeIndex == -1 ? -1 : 0)
                    }
                    
                    ForEach(Array(filterElements(type: $choosedPartModel, genderType: $genderType).enumerated()), id: \.element.id) { index, item in
                        ElementCellForEditor(imageName: item.previewImageString ?? "", choosedImageName: $choosedPart, tappedOnImage: {
                            changeIndex = index
                        }, imageData: item.previewImage, sendBackImageData: {data in
                            item.previewImage = data
                            try? viewContext.save()
                        }, index: index, choosedIndex: $changeIndex, showInternetAlert: $showInternetAlert)
                        .id(index)
                    }
                }
                .padding(.leading, bigSize ? 40 : 20)
                
            }
            .padding(.bottom, 5)
            .onAppear() {
                scrollProxy = proxy
            }
        }
        .frame(height: bigSize ? 200 : 110)
    }
    
    private func filterElements(type: Binding<EditorTypePartOfBody?>, genderType: Binding<GenderTypeModel>) -> [BodyElement] {
        let genderFilter = allElementData.filter({$0.genderType == genderType.wrappedValue.rawValue})
        let secondFilter = genderFilter.filter({$0.typeOfPart == type.wrappedValue?.rawValue ?? 0})
        return secondFilter
    }
    
    private func setImageToSandvich(type: Binding<EditorTypePartOfBody?>, removeImage: Bool = false) {
        viewMotel.setImageToSandvich(type: type.wrappedValue, removeImage: removeImage, choosedPart: choosedPart, choosedPartModel: choosedPartModel, genderType: genderType, allData: allElementData)
        arrayOfSandvichImages = viewMotel.sandvichPeople.sendAllImages()
    }
    
    private func changeGenderType(){
        switch genderType {
        case .man:
            if viewMotel.tempManPeople != nil {
                viewMotel.tempWomanPeople = viewMotel.sandvichPeople
                viewMotel.sandvichPeople = viewMotel.tempManPeople!
            } else {
                viewMotel.tempWomanPeople = viewMotel.sandvichPeople
                viewMotel.sandvichPeople.allNil()
                changeIndex = 0
            }
        case .woman:
            if viewMotel.tempWomanPeople != nil {
                viewMotel.tempManPeople = viewMotel.sandvichPeople
                viewMotel.sandvichPeople = viewMotel.tempWomanPeople!
            } else {
                viewMotel.tempManPeople = viewMotel.sandvichPeople
                viewMotel.sandvichPeople.allNil()
                changeIndex = 0
            }
        }
        arrayOfSandvichImages = viewMotel.sandvichPeople.sendAllImages()
        setImageToSandvich(type: $choosedPartModel)
        if choosedPartModel == .body {
            switch genderType {
            case .man:
                choodedTitle = "Man".capitalized
            case .woman:
                choodedTitle = "Woman".capitalized
            }
        } else {
            choodedTitle = choosedPartModel?.stringValue().capitalized ?? ""
        }
        
    }
}
