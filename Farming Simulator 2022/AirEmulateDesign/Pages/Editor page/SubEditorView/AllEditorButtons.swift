//
//  AllEditorButtons.swift
//  Farming Simulator 2022
//
//  Created by Sim on 01/10/24.
//

import SwiftUI

struct AllEditorButtons: View {
    enum GenderType {
        case man
        case woman
    }
    
    @Binding var tappeedButton: EditorTypePartOfBody?
    @Binding var dismissLayer: Bool
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var showGenderChoose: Bool = false
    @State var selectedGender: (GenderType) -> Void
    
    var body: some View {
        // Bottom sheet container
        VStack(spacing: 12) {
            // Menu options
            VStack(spacing: 8) {
                ForEach(EditorTypePartOfBody.allCases) { item in
                    menuButton(for: item)
                }
            }
            .padding(.horizontal, 16)
            
            // Bottom indicator bar
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 134, height: 5)
                .cornerRadius(2.5)
                .padding(.bottom, bigSize ? 20 : 8)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color(red: 0.133, green: 0.365, blue: 0.239)
                .opacity(0.95)
        )
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
    
    @ViewBuilder
    private func menuButton(for item: EditorTypePartOfBody) -> some View {
        Button {
            if item == .body {
                showGenderChoose.toggle()
            } else {
                tappeedButton = item
                withAnimation {
                    dismissLayer.toggle()
                }
            }
        } label: {
            HStack {
                Text(item.stringValue().capitalized)
                    .font(FontTurboGear.gilroyStyle(
                        size: bigSize ? 20 : 17,
                        type: .medium
                    ))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Show chevron only for Gender/Body option
                if item == .body {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(showGenderChoose ? 180 : 0))
                        .animation(.easeInOut, value: showGenderChoose)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: bigSize ? 56 : 44)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill()
            )
        }
        .overlay {
            if showGenderChoose && item == .body {
                genderSelectionOverlay
            }
        }
    }
    
    private var genderSelectionOverlay: some View {
        VStack(spacing: 8) {
            Button {
                selectedGender(.man)
                tappeedButton = .body
                withAnimation {
                    dismissLayer.toggle()
                }
            } label: {
                Text("Man")
                    .font(FontTurboGear.gilroyStyle(
                        size: bigSize ? 20 : 17,
                        type: .medium
                    ))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: bigSize ? 56 : 44)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.133, green: 0.365, blue: 0.239))
                    )
            }
            
            Button {
                selectedGender(.woman)
                tappeedButton = .body
                withAnimation {
                    dismissLayer.toggle()
                }
            } label: {
                Text("Woman")
                    .font(FontTurboGear.gilroyStyle(
                        size: bigSize ? 20 : 17,
                        type: .medium
                    ))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: bigSize ? 56 : 44)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.133, green: 0.365, blue: 0.239))
                    )
            }
        }
        .padding(.horizontal, 16)
        .background(
            Color(red: 0.133, green: 0.365, blue: 0.239)
                .opacity(0.95)
        )
        .cornerRadius(8)
        .transition(.opacity)
    }
}
