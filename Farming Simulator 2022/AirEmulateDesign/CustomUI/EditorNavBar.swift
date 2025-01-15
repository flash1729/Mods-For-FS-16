//
//  EditorNavBar.swift
//  Farming Simulator 2022
//
//  Created by Aditya Medhane on 09/01/25.
//

import SwiftUI

struct EditorNavBar: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    // State and bindings
    var isEditing: Bool  // Controls nav bar state (initial vs editing)
    var viewMotel: EditorViewModel
    @Binding var showSaveState: Bool
    @Binding var saveStateType: IconTurboGear.SaveStateIconTurbo
    @State private var downloadState: DownloadState = .initial
    @State private var isLoading: Bool = false
    
    // Constants
    private let buttonSize: CGFloat = 44
    
    var body: some View {
        VStack(spacing: 0) {
            // Status overlay
            if showSaveState {
                SaveConfirmationAlertView(saveState: $saveStateType)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.showSaveState = false
                        }
                    }
            }
            
            // Navigation bar content
            HStack(spacing: 12) {
                if isEditing {
                    // Back button when editing
                    Button {
                        dismiss()
                    } label: {
                        Image("backButtonGreen")
                            .resizable()
                            .scaledToFit()
                            .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                    }
                }
                
                // Title
                Text("Editor")
                    .font(FontTurboGear.gilroyStyle(size: bigSize ? 44 : 32, type: .bold))
                    .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                if !isEditing {
                    // Menu button in initial state
                    Button {
                        dismiss()
                    } label: {
                        Image("menuHam")
                            .resizable()
                            .scaledToFit()
                            .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                    }
                } else {
                    // Download button when editing
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
        isLoading = true
        
        // Simulating download progress
        // Replace with actual save/download logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if let imageData = viewMotel.fullImagePeopleToSave?.pngData() {
                viewMotel.requestPhotoLibraryPermission { granted in
                    if granted, let image = UIImage(data: imageData) {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        downloadState = .success
                    } else {
                        downloadState = .failure
                    }
                    isLoading = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        downloadState = .initial
                    }
                }
            }
        }
    }
}

// MARK: - Preview Provider
struct EditorNavBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Initial state
            EditorNavBar(
                isEditing: false,
                viewMotel: EditorViewModel(),
                showSaveState: .constant(false),
                saveStateType: .constant(.saveSuccesfulIconElement)
            )
            .previewDisplayName("Initial State")
            
            // Editing state
            EditorNavBar(
                isEditing: true,
                viewMotel: EditorViewModel(),
                showSaveState: .constant(false),
                saveStateType: .constant(.saveSuccesfulIconElement)
            )
            .previewDisplayName("Editing State")
        }
    }
}
