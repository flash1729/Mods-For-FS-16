//
//  BottomFilterBarView.swift
//  Farming Simulator 2022
//
//  Created by Aditya Medhane on 27/12/24.
//

import SwiftUI

//struct BottomFilterBarView: View {
//    // MARK: - Properties
//    @Binding var filterType: IconTurboGear.FilterIconTurbo
//    let choosedFilter: (IconTurboGear.FilterIconTurbo) -> Void
//    
//    // Device check for responsive sizing
//    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
//    
//    // MARK: - Body
//    var body: some View {
//        VStack(spacing: 0) {
//            // Filter buttons container
//            HStack {
//                filterButtonElement(typeElement: .filterAllItems, choosedType: $filterType)
//                filterButtonElement(typeElement: .filterNewItems, choosedType: $filterType)
//                filterButtonElement(typeElement: .filterFavoriteItems, choosedType: $filterType)
//                filterButtonElement(typeElement: .filterTopItems, choosedType: $filterType)
//            }
//            .padding(.horizontal, bigSize ? 40 : 20)
//            .padding(.vertical, bigSize ? 20 : 16)
//        }
//        .background(
//                GeometryReader { geometry in
//                    ColorTurboGear.colorPicker(.green)
//                        .cornerRadius(16, corners: [.topLeft, .topRight])
//                        .edgesIgnoringSafeArea(.bottom)
//                }
//            )
//    }
//    
//    // MARK: - Helper Views
//    private func filterButtonElement(typeElement: IconTurboGear.FilterIconTurbo, choosedType: Binding<IconTurboGear.FilterIconTurbo>) -> some View {
//        Button {
//            choosedType.wrappedValue = typeElement
//            if typeElement == choosedType.wrappedValue {
//                choosedFilter(typeElement)
//            }
//        } label: {
//            FilterIconInNav(iconType: typeElement, choosedIconType: choosedType)
//        }
//        .frame(maxWidth: .infinity)
//    }
//}

struct BottomFilterBarView: View {
    @Binding var filterType: IconTurboGear.FilterIconTurbo
    let choosedFilter: (IconTurboGear.FilterIconTurbo) -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter buttons container
            HStack(spacing: bigSize ? 16 : 8) {
                ForEach(IconTurboGear.FilterIconTurbo.allCases, id: \.self) { item in
                    Button(action: {
                        filterType = item
                        choosedFilter(item)
                    }) {
                        Text(item.sendTitleOfIcon())
                            .font(FontTurboGear.gilroyStyle(
                                size: bigSize ? 28 : 14,
                                type: .medium
                            ))
                            .foregroundColor(
                                item == filterType ?
                                ColorTurboGear.colorPicker(.darkGreen) :
                                .white
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: bigSize ? 44 : 34)
                            .background(
                                item == filterType ?
                                    Color.white :
                                    ColorTurboGear.colorPicker(.darkGreen)
                            )
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        item == filterType ?
                                        ColorTurboGear.colorPicker(.darkGreen) :
                                        Color.clear,
                                        lineWidth: 1
                                    )
                            )
                    }
                }
            }
            .padding(.horizontal, bigSize ? 32 : 20)
            .padding(.vertical, bigSize ? 24 : 16)
        }
        .background(
            ColorTurboGear.colorPicker(.darkGreen)
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)
        )
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
