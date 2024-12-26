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
        LazyVGrid(columns:
                    Array(repeating: GridItem(.flexible(minimum: bigSize ? 200 : 95, maximum: bigSize ? 240 : 105), spacing: bigSize ? 30 : 10), count: 3)
                  , spacing: bigSize ? 30 : 10) {
            ForEach(EditorTypePartOfBody.allCases) { item in
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
                    RoundedRectangle(cornerRadius: bigSize ? 33 : 16)
                        .fill(ColorTurboGear.colorPicker(.cyan))
                        .frame(height: bigSize ? 240 : 113)
                        .overlay {
                            ZStack {
                                if showGenderChoose && item == .body {
                                    VStack(spacing: 10){
                                        Button {
                                            selectedGender(.man)
                                            tappeedButton = item
                                            withAnimation {
                                                dismissLayer.toggle()
                                            }
                                        } label: {
                                            Text("Man")
                                                .font(FontTurboGear.montserratStyle(size: bigSize ? 34 : 16, type: .semibold))
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                        }
                                        Button {
                                            selectedGender(.woman)
                                            tappeedButton = item
                                            withAnimation {
                                                dismissLayer.toggle()
                                            }
                                        } label: {
                                            Text("Woman")
                                                .font(FontTurboGear.montserratStyle(size: bigSize ? 34 : 16, type: .semibold))
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                        }
                                    }
                                } else {
                                    Text(item.stringValue().capitalized)
                                        .font(FontTurboGear.montserratStyle(size: bigSize ? 34 : 16, type: .semibold))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                }
                            }
                        }
                }
                
            }
        }
        
    }
}
