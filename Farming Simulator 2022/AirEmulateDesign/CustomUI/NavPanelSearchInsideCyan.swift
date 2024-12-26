//
//  NavPanelSearchInsideCyan.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct NavPanelSearchInsideCyan: View {
    @Environment(\.dismiss) var dismiss
    @Binding var searchText: String
    @Binding var filterType: IconTurboGear.FilterIconTurbo
    @State var searchTypeElement: SearchPanelWhiteGray.SearchType
    @State var onCommit: () -> Void
    @State var choosedFilter: (IconTurboGear.FilterIconTurbo) -> Void
    @State var showSearchPanel: Bool = true
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    NavButtonMiniIcon(typeOfImage: IconTurboGear.TopNavIconTurbo.windowIcon)
                }
                Text("\(searchTypeElement.rawValue.capitalized)s")
                    .font(FontTurboGear.montserratStyle(size: 24, type: .bold))
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                NavButtonMiniIcon(typeOfImage: IconTurboGear.TopNavIconTurbo.windowIcon)
                    .opacity(0)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, showSearchPanel ? 0 : 20)
            if showSearchPanel {
                SearchPanelWhiteGray(searchTypeElement: searchTypeElement, searchText: $searchText, onCommit: onCommit)
            }
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
        .background(
            ZStack {
                ColorTurboGear.colorPicker(.cyan)
                Color.clear
                    .contentShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
            }
        )
        .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
    }
    
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
    NavPanelSearchInsideCyan(searchText: .constant(""), filterType: .constant(.filterAllItems), searchTypeElement: .plane, onCommit: {}, choosedFilter: {_ in})
}
