//
//  NavPanelSearchInsideCyan.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct NavPanelSearchInsideGreen: View {
    @Environment(\.dismiss) var dismiss
    @Binding var searchText: String
    @Binding var filterType: IconTurboGear.FilterIconTurbo
    @State var searchTypeElement: SearchPanelWhiteGray.SearchType
    @State var onCommit: () -> Void
    @State var choosedFilter: (IconTurboGear.FilterIconTurbo) -> Void
    @State var showSearchPanel: Bool = false
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    // Add state for controlling search expansion
    @State private var isSearchExpanded = false
    
    var body: some View {
        VStack(spacing: 10) {
            // Top Navigation Bar
            HStack(spacing: 12) {
                Text("\(searchTypeElement.rawValue.capitalized)s")
                    .font(FontTurboGear.gilroyStyle(size: 32, type: .bold))
                    .foregroundStyle(ColorTurboGear.colorPicker(.green))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                // Right-aligned buttons
                HStack(spacing: 8) {
                    Button {
                        dismiss()
                    } label: {
                        Image("menuHam")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(ColorTurboGear.colorPicker(.green))
                            .frame(width: 44, height: 44)
                    }
                    
                    Button {
                        withAnimation {
                            showSearchPanel.toggle()
                        }
                    } label: {
                        Image("searchIcon")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(ColorTurboGear.colorPicker(.green))
                            .frame(width: 44, height: 44)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, showSearchPanel ? 0 : 20)
            
            // Search Panel
            if showSearchPanel {
                SearchPanelWhiteGray(
                    searchTypeElement: searchTypeElement,
                    searchText: $searchText,
                    onCommit: onCommit
                )
            }
            
            // Filter Buttons
            HStack {
                filterButtonElement(typeElement: .filterAllItems, choosedType: $filterType)
                filterButtonElement(typeElement: .filterNewItems, choosedType: $filterType)
                filterButtonElement(typeElement: .filterFavoriteItems, choosedType: $filterType)
                filterButtonElement(typeElement: .filterTopItems, choosedType: $filterType)
            }
        }
        .foregroundColor(.white)
        .paddingFlyBullet()
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .frame(height: showSearchPanel ? 245 : (bigSize ? 220 : 200))
//        .background(
//            ZStack {
//                ColorTurboGear.colorPicker(.green)
//                Color.clear
//                    .contentShape(RoundedRectangle(cornerRadius: 12))
//                    .onTapGesture {
//                        UIApplication.shared.endEditing()
//                    }
//            }
//        )
        .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
    }
    
    // Keeping your existing filter button implementation
    private func filterButtonElement(typeElement: IconTurboGear.FilterIconTurbo, choosedType: Binding<IconTurboGear.FilterIconTurbo>) -> some View {
        Button {
            choosedType.wrappedValue = typeElement
            if typeElement == choosedType.wrappedValue {
                choosedFilter(typeElement)
            }
        } label: {
            FilterIconInNav(iconType: typeElement, choosedIconType: choosedType)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavPanelSearchInsideGreen(searchText: .constant(""), filterType: .constant(.filterAllItems), searchTypeElement: .plane, onCommit: {}, choosedFilter: {_ in})
}
