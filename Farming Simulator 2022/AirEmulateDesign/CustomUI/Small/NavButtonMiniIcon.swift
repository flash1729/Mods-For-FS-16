//
//  NavButtonMiniIcon.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct NavButtonMiniIcon: View {
    @State var typeOfImage: IconTurboGear.TopNavIconTurbo
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(Color.white.opacity(0.44))
            .frame(width: 44, height: 44)
            .overlay {
                Image(typeOfImage.sendNameOfIcon())
                    .resizable()
                    .scaledToFit()
                    .padding(10)
            }
    }
}

#Preview {
    NavButtonMiniIcon(typeOfImage: .backChev)
}
