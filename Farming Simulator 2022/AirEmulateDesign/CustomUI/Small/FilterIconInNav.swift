//
//  FilterIconInNav.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct FilterIconInNav: View {
    @State var iconType: IconTurboGear.FilterIconTurbo
    @Binding var choosedIconType: IconTurboGear.FilterIconTurbo
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        VStack {
            Image(iconType.rawValue)
                .resizable()
                .scaledToFit()
                .frame(height: bigSize ? 30 : 24)
            Text(iconType.sendTitleOfIcon())
                .font(FontTurboGear.montserratStyle(size: bigSize ? 18 : 14, type: .medium))
        }
        .foregroundColor(iconType == choosedIconType ? Color.white : ColorTurboGear.colorPicker(.darkGray))
    }
}

#Preview {
    FilterIconInNav(iconType: .filterAllItems, choosedIconType: .constant(.filterAllItems))
}
