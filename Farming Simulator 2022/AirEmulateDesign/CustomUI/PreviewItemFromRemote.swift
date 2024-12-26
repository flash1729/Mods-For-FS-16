//
//  PreviewItemFromRemote.swift
//  Farming Simulator 2022
//
//  Created by Sim on 26/09/24.
//

import SwiftUI

struct PreviewItemFromRemote: View {
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @EnvironmentObject var dropBoxManager: DropBoxManager_SimulatorFarm
    @ObservedObject var networkManager = NetworkManager_SimulatorFarm()
    @State var imageData: Data? = nil
    @State var imagePath: String
    @State var titleData: String?
    @State var previewText: String?
    @Binding var likeState: Bool
    @State var tappedLikeButton: (Bool) -> Void
    @State var openDescriptionItem: () -> Void
    @State var sendBackImageData: (Data) -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: bigSize ? 31 : 17) {
            Button {
                openDescriptionItem()
            } label: {
                RoundedRectangle(cornerRadius: bigSize ? 36 : 20)
                    .fill(Color.white)
                    .frame(maxHeight: bigSize ? 578 : 318)
                    .overlay {
                        ZStack {
                            Image(uiImage: UIImage(data: imageData ?? Data()) ?? UIImage())
                                .resizable()
                                .scaledToFill()
                            if imageData == nil {
                                ColorTurboGear.colorPicker(.darkGray)
                                InfinityLoaderCyan()
                                    .frame(height: 55)
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }

            HStack {
                Text(titleData ?? "...")
                    .font(FontTurboGear.montserratStyle(size: bigSize ? 33 : 18, type: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                FavoritHeartButtonCyan(stateFavoritHeart: $likeState, onTapButton: tappedLikeButton)
            }
            Text(previewText ?? "...")
                .font(FontTurboGear.montserratStyle(size: bigSize ? 25 : 14, type: .regular))
                .lineLimit(2)
        }
        .foregroundColor(.white)
    }
}

#Preview {
    PreviewItemFromRemote(imagePath: "", likeState: .constant(true), tappedLikeButton: {_ in}, openDescriptionItem: {}, sendBackImageData: {_ in})
}
