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
            // Search field with placeholder
            TextField("", text: $searchText, onCommit: onCommit)
                .placeholder(when: searchText.isEmpty) {
                    Text("Search \(searchTypeElement.rawValue)")
                        .foregroundColor(Color.gray.opacity(0.6))
                        .font(FontTurboGear.gilroyStyle(
                            size: bigSize ? 16 : 14,
                            type: .medium
                        ))
                }
                .font(FontTurboGear.gilroyStyle(
                    size: bigSize ? 16 : 14,
                    type: .medium
                ))
                .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                .padding(.leading, 16)
                .onAppear {
                    DispatchQueue.main.async {
                        // Focus the text field when it appears
                        UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder),
                                                     to: nil,
                                                     from: nil,
                                                     for: nil)
                    }
                }
            
            // Dismiss button
            Button {
                searchText = ""
                withAnimation {
                    showSearchPanel = false
                }
            } label: {
                Image("xmarkGreen")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .background(Color.gray.opacity(0.15))
            }
            .padding(.trailing, 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(
            color: .black.opacity(0.5),
            radius: 2,
            x: 0,
            y: 1
        )
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
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
