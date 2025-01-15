//
//  AvatarGenNavBar.swift
//  Farming Simulator 2022
//
//  Created by Aditya Medhane on 09/01/25.
//

import SwiftUI

import SwiftUI

struct AvatarGenNavBar: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    // State
    var isGenerating: Bool
    var viewMotel: EditorViewModel
    var genderType: GenderTypeModel
    @Binding var showEditConfigurator: Bool
    @Binding var choosedData: BodyEditor?
    
    @State private var downloadState: DownloadState = .initial
    @State private var showSaveState: Bool = false
    @State private var saveStateType: IconTurboGear.SaveStateIconTurbo = .saveSuccesfulIconElement
    @State private var isLoading: Bool = false
    
    // Constants for sizing
    private let standardPadding: CGFloat = 20
    private let buttonSize: CGFloat = 44
    
    var body: some View {
        VStack(spacing: 0) {
            // Save state overlay
            if showSaveState {
                SaveStateCustomView(saveState: $saveStateType)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.showSaveState = false
                        }
                    }
            }
            
            // Navigation bar content
            HStack(spacing: 12) {
                if isGenerating {
                        // Back button on left when generating
                        Button {
                            dismiss()
                        } label: {
                            Image("backButtonGreen")
                                .resizable()
                                .scaledToFit()
                                .frame(width: bigSize ? 80 : buttonSize, height: bigSize ? 80 : buttonSize)
                        }
                    }
                    
                Text("Avatar gen")
                    .font(FontTurboGear.gilroyStyle(size: bigSize ? 34 : 32, type: .bold))
                    .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                if !isGenerating {
                        // Menu button on right when not generating
                        Button {
                            dismiss()
                        } label: {
                            Image("menuHam")
                                .resizable()
                                .scaledToFit()
                                .frame(width: bigSize ? 80 : buttonSize, height: bigSize ? 80 : buttonSize)
                        }
                    }
                
                // Right-side buttons when generating
                if isGenerating {
                    HStack(spacing: 8) {
                        // Download Button with states
                        Button(action: handleDownload) {
                            Group {
                                switch downloadState {
                                case .initial:
                                    Image("downloadButtonGreen")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                                
                                case .downloading(let progress):
                                    ZStack {
                                        Circle()
                                            .stroke(
                                                Color.gray.opacity(0.3),
                                                lineWidth: 3
                                            )
                                        
                                        Circle()
                                            .trim(from: 0, to: CGFloat(progress))
                                            .stroke(
                                                ColorTurboGear.colorPicker(.darkGreen),
                                                style: StrokeStyle(
                                                    lineWidth: 3,
                                                    lineCap: .round
                                                )
                                            )
                                            .rotationEffect(.degrees(-90))
                                        
                                        Text("\(Int(progress * 100))%")
                                            .font(FontTurboGear.gilroyStyle(size: 12, type: .medium))
                                            .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                                    }
                                
                                case .success:
                                    Image("downCompleteIcon")
                                        .resizable()
                                        .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                                        .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                                
                                case .failure:
                                    Image("downFailIcon")
                                        .resizable()
                                        .foregroundColor(.red)
                                        .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                                }
                            }
                            .frame(width: buttonSize, height: buttonSize)
                        }
                        .disabled({
                            switch downloadState {
                            case .initial: return isLoading
                            case .downloading, .success, .failure: return true
                            }
                        }())
                        
                        // Edit Button
                        Button(action: handleEdit) {
                            Image("editAvatar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
        .paddingFlyBullet()
        .padding(.vertical, bigSize ? 24 : 20)
        .frame(maxWidth: .infinity)
        .frame(height: bigSize ? 137 : 128)
        .background(Color.white)
    }
    
    private func handleDownload() {
        downloadState = .downloading(progress: 0)
        
        viewMotel.saveItemToCoreData(
            item: viewMotel.randomItem,
            viewContext: viewContext,
            genderType: genderType,
            randomType: true
        ) { success in
            if success {
                downloadState = .success
            } else {
                downloadState = .failure
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                downloadState = .initial
            }
        }
    }
    
//    private func handleEdit() {
//            viewMotel.updateData = true
//            viewMotel.sandvichPeople = viewMotel.randomItem
//            showEditConfigurator = true
//        }
    
    private func handleEdit() {
            let tempEditor = BodyEditor(context: viewContext)
            viewMotel.updateWithoutSaveItemTCoreData(
                updateItem: tempEditor,
                item: viewMotel.randomItem,
                genderType: genderType,
                randomType: true
            )
            
            choosedData = tempEditor
            viewMotel.updateData = true
            viewMotel.sandvichPeople = viewMotel.randomItem
            showEditConfigurator = true
        }
    
//    private func handleEdit() {
//            // Create temporary BodyEditor in viewContext
//            let tempEditor = BodyEditor(context: viewContext)
//            
//            // Update temp editor with current random configuration
//            viewMotel.updateWithoutSaveItemTCoreData(updateItem: tempEditor,
//                                                    item: viewMotel.randomItem,
//                                                    genderType: genderType,
//                                                    randomType: true)
//            
//            // Set as current data
//            viewMotel.updateData = true
//            viewMotel.sandvichPeople = viewMotel.randomItem
//            
//            // Update images
//            let _ = viewMotel.mergeImages(from: viewMotel.randomItem.sendAllImages())
//            
//            // Show configurator
//            showEditConfigurator = true
//        }
}

//// MARK: - Preview Provider
//struct AvatarGenNavBar_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            // Before generating
//            AvatarGenNavBar(
//                isGenerating: false,
//                viewMotel: EditorViewModel(),
//                genderType: .man,
//                showEditConfigurator: .constant(false)
//            )
//            .previewDisplayName("Before Generating")
//            
//            // After generating
//            AvatarGenNavBar(
//                isGenerating: true,
//                viewMotel: EditorViewModel(),
//                genderType: .man,
//                showEditConfigurator: .constant(false)
//            )
//            .previewDisplayName("After Generating")
//        }
//    }
//}
