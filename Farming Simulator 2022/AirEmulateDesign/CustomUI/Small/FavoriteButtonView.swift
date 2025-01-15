//
//  FavoritHeartButtonCyan.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct FavoriteButtonView: View {
    @Binding var stateFavoritHeart: Bool
    @State var onTapButton: (Bool) -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        Button {
            stateFavoritHeart.toggle()
            onTapButton(stateFavoritHeart)
        } label: {
            Image(stateFavoritHeart ? IconTurboGear.FavoritHeartIconTurbo.favoriteHeartCyan : IconTurboGear.FavoritHeartIconTurbo.unfavoriteHeartCyan)
                .resizable()
                .scaledToFit()
                .frame(width: bigSize ? 58 : 44,height: bigSize ? 58 : 44)
        }

    }
}

#Preview {
    FavoriteButtonView(stateFavoritHeart: .constant(true), onTapButton: {_ in})
}
