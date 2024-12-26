//
//  MuneBoardForMainPage.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct MuneBoardForMainPage: View {
    @State var iconType: IconTurboGear.MenuIconTurbo
    @Binding var choosedItem: IconTurboGear.MenuIconTurbo?
    @Binding var openPage: Bool
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        Button {
            choosedItem = iconType
            openPage.toggle()
        } label: {
            HStack {
                Image(iconType.sendNameOfIcon())
                    .resizable()
                    .scaledToFit()
                    .frame(width: bigSize ? 62 : 42)
                
                Text(iconType.sendTitleOfItem())
                    .font(FontTurboGear.montserratStyle(size: bigSize ? 30 : 20, type: .semibold))
                    .minimumScaleFactor(0.7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }
            .padding(.leading, bigSize ? 95 : 70)
            .padding(.trailing, bigSize ? 40 : 20)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: bigSize ? 110 : 73)
            .foregroundColor(.white)
            .background(
                BlueBackgroundWithBorder(cornerRadiusCustom: bigSize ? 16 : 20)
            )
            .compositingGroup()
        }

    }
}

#Preview {
    MuneBoardForMainPage(iconType: .nickGen, choosedItem: .constant(.dads), openPage: .constant(false))
}
