//
//  BottomFilterBarView.swift
//  Farming Simulator 2022
//
//  Created by Aditya Medhane on 27/12/24.
//

import SwiftUI

struct BottomFilterBarView: View {
    // MARK: - Properties
    @Binding var filterType: IconTurboGear.FilterIconTurbo
    let choosedFilter: (IconTurboGear.FilterIconTurbo) -> Void
    
    // Device check for responsive sizing
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Filter buttons container
            HStack {
                filterButtonElement(typeElement: .filterAllItems, choosedType: $filterType)
                filterButtonElement(typeElement: .filterNewItems, choosedType: $filterType)
                filterButtonElement(typeElement: .filterFavoriteItems, choosedType: $filterType)
                filterButtonElement(typeElement: .filterTopItems, choosedType: $filterType)
            }
            .padding(.horizontal, bigSize ? 40 : 20)
            .padding(.vertical, bigSize ? 20 : 16)
        }
        .background(
                GeometryReader { geometry in
                    ColorTurboGear.colorPicker(.green)
                        .cornerRadius(16, corners: [.topLeft, .topRight])
                        .edgesIgnoringSafeArea(.bottom)
                }
            )
    }
    
    // MARK: - Helper Views
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

// MARK: - Preview
struct BottomFilterBarView_Previews: PreviewProvider {
   static var previews: some View {
       
           // Preview with All filter
           BottomFilterBarView(
               filterType: .constant(.filterAllItems),
               choosedFilter: { _ in }
           )
   }
}
