//
//  SearchPanelWhiteGray.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct SearchPanelWhiteGray: View {
    enum SearchType: String {
        case dads = "mod"
        case maps = "map"
        case plane = "wallpaper"
        case farm = "skin"
    }
    
    @State var searchTypeElement: SearchType
    @Binding var searchText: String
    @Binding var showSearchPanel: Bool  // Added to handle search panel visibility
    @State var onCommit: () -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        HStack(spacing: 12) {
            // Search field
            TextField("Search \(searchTypeElement.rawValue)", text: $searchText, onCommit: onCommit)
                .font(FontTurboGear.gilroyStyle(
                    size: bigSize ? 16 : 14,
                    type: .medium
                ))
                .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                .padding(.leading, 16)
            
            // Dismiss button - always visible
            Button {
                searchText = ""
                withAnimation {
                    showSearchPanel = false
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                    .frame(width: 20, height: 20)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(Circle())
            }
            .padding(.trailing, 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(
            color: .black.opacity(0.1),
            radius: 2,
            x: 0,
            y: 1
        )
    }
}

// Preview
struct SearchPanelWhiteGray_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            
            SearchPanelWhiteGray(
                searchTypeElement: .dads,
                searchText: .constant(""),
                showSearchPanel: .constant(true),
                onCommit: {}
            )
            .padding()
        }
    }
}
