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
    @State var onCommit: () -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            ZStack {
                if searchText.isEmpty {
                    Text("Search \(searchTypeElement.rawValue)")
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                TextField("", text: $searchText, onCommit: onCommit)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorTurboGear.colorPicker(.darkGray))
            }
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .font(FontTurboGear.montserratStyle(size: bigSize ? 14 : 11, type: .regular))
        .padding(.horizontal, 19)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .foregroundColor(Color.gray.opacity(0.75))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    SearchPanelWhiteGray(searchTypeElement: .dads, searchText: .constant(""), onCommit: {})
}
