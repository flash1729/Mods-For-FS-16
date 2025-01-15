//
//  NavPanelSearchInsideCyan.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct NavigationPanelWithSearchController: View {
    @Environment(\.dismiss) var dismiss
    @Binding var searchText: String
    @Binding var filterType: IconTurboGear.FilterIconTurbo
    @State var searchTypeElement: SearchPanelWhiteGray.SearchType
    @State var onCommit: () -> Void
    @State var choosedFilter: (IconTurboGear.FilterIconTurbo) -> Void
    @State var showSearchPanel: Bool = false
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        VStack(spacing: 10) {
            // Using Group to conditionally show either the header or search panel
            Group {
                if showSearchPanel {
                    // Search Panel that replaces the header
                    SearchPanelWhiteGray(
                        searchTypeElement: searchTypeElement,
                        searchText: $searchText, showSearchPanel: $showSearchPanel,
                        onCommit: onCommit
                    )
                    .transition(.opacity) // Smooth transition when switching views
                } else {
                    // Header content
                    HStack(spacing: 12) {
                        Text("\(searchTypeElement.rawValue.capitalized)s")
                            .font(FontTurboGear.gilroyStyle(size: bigSize ? 44 : 32, type: .bold))
                            .foregroundStyle(ColorTurboGear.colorPicker(.green))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        HStack(spacing: 8) {
                            Button {
                                dismiss()
                            } label: {
                                Image("menuHam")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(ColorTurboGear.colorPicker(.green))
                                    .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
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
                                    .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                            }
                        }
                    }
                    .frame(maxHeight: 44, alignment: .center)
                    .transition(.opacity)
                }
            }
        }
        .foregroundColor(.white)
        .paddingFlyBullet()
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        // Simplified height calculation since we don't need extra space for the search panel
        .frame(height: bigSize ? 140 : 60)
        .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
    }
}

#Preview {
    NavigationPanelWithSearchController(searchText: .constant(""), filterType: .constant(.filterAllItems), searchTypeElement: .plane, onCommit: {}, choosedFilter: {_ in})
}
