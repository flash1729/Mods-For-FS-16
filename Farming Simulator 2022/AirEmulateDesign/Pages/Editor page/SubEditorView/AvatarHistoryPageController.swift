//
//  RandomHistoryPage.swift
//  Farming Simulator 2022
//
//  Created by Sim on 01/10/24.
//

import SwiftUI
import CoreData

class PreviewHelpers {
    static func createMockBodyEditor() -> BodyEditor {
        let context = PersistenceController.shared.container.viewContext
        let bodyEditor = BodyEditor(context: context)
        bodyEditor.idPeople = UUID()
        bodyEditor.date = Date()
        bodyEditor.randomKey = true
        bodyEditor.gender = 0 // man
        
        // Create a sample image
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 200, height: 300))
        let sampleImage = renderer.image { context in
            // Draw a gradient background
            let colors = [
                UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0).cgColor,
                UIColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1.0).cgColor
            ]
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors as CFArray,
                locations: [0, 1]
            )!
            context.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: 0, y: 300),
                options: []
            )
            
            // Draw avatar shape
            UIColor.white.setFill()
            let circlePath = UIBezierPath(ovalIn: CGRect(x: 70, y: 60, width: 60, height: 60))
            circlePath.fill()
            
            let bodyPath = UIBezierPath(roundedRect: CGRect(x: 85, y: 120, width: 30, height: 100), cornerRadius: 10)
            bodyPath.fill()
        }
        
        bodyEditor.smallPreviewImage = sampleImage.pngData()
        bodyEditor.fullImage = sampleImage.pngData()
        
        return bodyEditor
    }
}

struct AvatarHistoryPageController: View {
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
            Color.white.ignoresSafeArea()
            
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
                NavPanelGreenWithBackButton(titleName: "History")
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
                DeleteConfirmationAlertView { state in
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
                    Self.cellToCollection(
                        item: item,
                        choosedData: $choosedData,
                        deleteAlert: $deleteAlert,
                        showSaveAlert: $showSaveAlert,
                        dismissAction: { dismiss() },
                        editCompletion: choosedToEditCompletion
                    )
                }
            }
            .padding(.top, bigSize ? 30 : 10)
        }
    }
    
    struct CustomGreenButton: View {
        enum ButtonSize {
            case large   // For Upload
            case small   // For Edit
            
            var width: CGFloat {
                switch self {
                case .large:
                    return UIDevice.current.userInterfaceIdiom == .pad ? 160 : 148
                case .small:
                    return UIDevice.current.userInterfaceIdiom == .pad ? 100 : 72
                }
            }
        }
        
        let action: () -> Void
        let title: String
        let size: ButtonSize
        let bigSize = UIDevice.current.userInterfaceIdiom == .pad
        
        var body: some View {
            GreenButtonRounded(
                blueButtonTap: action,
                titleButton: title
            )
            .frame(width: size.width,height: 16)
        }
    }
    
    static func cellToCollection(
        item: BodyEditor,
        choosedData: Binding<BodyEditor?>,
        deleteAlert: Binding<Bool>,
        showSaveAlert: Binding<Bool>,
        dismissAction: (() -> Void)? = nil,
        editCompletion: (() -> Void)? = nil
    ) -> some View {
        let bigSize = UIDevice.current.userInterfaceIdiom == .pad
        
        return VStack(spacing: 0) {
            // Image Container
            RoundedRectangle(cornerRadius: bigSize ? 24 : 16)
                .fill(ColorTurboGear.colorPicker(.grey))
                .frame(width: bigSize ? 345 : 154,height: bigSize ? 345 : 150)
                .overlay {
                    if let imageData = item.smallPreviewImage,
                       let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: bigSize ? 24 : 16))
                    }
                }
                .padding(.bottom, 8)
            
            // Buttons Container
            VStack(spacing: 4) {
                // Upload Button
                Button {
                    choosedData.wrappedValue = item
                    showSaveAlert.wrappedValue = true
                } label: {
                    Text("Upload")
                        .font(FontTurboGear.gilroyStyle(size: bigSize ? 22 : 16, type: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: 154)
                        .frame(height: 37)
                        .background(ColorTurboGear.colorPicker(.darkGreen))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                // Delete and Edit Row
                HStack(spacing: 8) {
                    // Delete Button
                    Button {
                        choosedData.wrappedValue = item
                        deleteAlert.wrappedValue.toggle()
                    } label: {
                        Text("Delete")
                            .font(FontTurboGear.gilroyStyle(size: bigSize ? 22 : 16, type: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 37)
                            .background(ColorTurboGear.colorPicker(.maroon))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .frame(maxWidth: 72, maxHeight: 34)
                    .layoutPriority(1)
                    
                    // Edit Button
                    Button {
                        choosedData.wrappedValue = item
                        editCompletion?()
                        dismissAction?()
                    } label: {
                        Text("Edit")
                            .font(FontTurboGear.gilroyStyle(size: bigSize ? 22 : 16, type: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 37)
                            .background(ColorTurboGear.colorPicker(.darkGreen))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .frame(maxWidth: 72, maxHeight: 34)
                    .layoutPriority(0.6)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .clipShape(RoundedRectangle(cornerRadius: bigSize ? 28 : 20))
    }
        
        static func buttonCustom(tapped: @escaping () -> Void, iconType: IconTurboGear.TopNavIconTurbo, redColor: Bool = false, bigSize: Bool) -> some View {
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
                            .padding(bigSize ? 20 : 10)
                    }
            }
            .frame(maxWidth: .infinity)
        }
    
    private var downloadSection: some View {
        VStack {
            if showSaveState {
                SaveConfirmationAlertView(saveState: $saveStateIphone)
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            self.showSaveState = false
                        })
                    }
            }
        }
    }
}

#Preview("History Page") {
    NavigationView {
        AvatarHistoryPageController(
            viewMotel: EditorViewModel(),
            choosedToEditCompletion: {},
            choosedData: .constant(PreviewHelpers.createMockBodyEditor())
        )
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(NetworkManager_SimulatorFarm())
        .environmentObject(DropBoxManagerModel_SimulatorFarm.shared)
    }
}

#Preview("History Cell") {
    VStack {
        // iPhone size
        AvatarHistoryPageController.cellToCollection(
            item: PreviewHelpers.createMockBodyEditor(),
            choosedData: .constant(nil),
            deleteAlert: .constant(false),
            showSaveAlert: .constant(false)
        )
        .frame(width: 180, height: 200)
        .padding()
        
        // iPad size
        AvatarHistoryPageController.cellToCollection(
            item: PreviewHelpers.createMockBodyEditor(),
            choosedData: .constant(nil),
            deleteAlert: .constant(false),
            showSaveAlert: .constant(false)
        )
        .frame(width: 360, height: 445)
        .padding()
    }
}

