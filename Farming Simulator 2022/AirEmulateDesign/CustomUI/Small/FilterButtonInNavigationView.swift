//
//  FilterIconInNav.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct FilterButtonInNavigationView: View {
    @State var iconType: IconTurboGear.FilterIconTurbo
    @Binding var choosedIconType: IconTurboGear.FilterIconTurbo
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        Text(iconType.sendTitleOfIcon())
            .font(FontTurboGear.gilroyStyle(
                size: bigSize ? 18 : 14,
                type: .medium
            ))
            .foregroundColor(
                iconType == choosedIconType ?
                ColorTurboGear.colorPicker(.green) : Color.white
            )
            .frame(width: 80, height: 34)
            .background(
                iconType == choosedIconType ?
                    Color.white :
                    ColorTurboGear.colorPicker(.darkGreen)
            )
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    FilterButtonInNavigationView(iconType: .filterAllItems, choosedIconType: .constant(.filterAllItems))
}
