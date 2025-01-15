//
//  PreviewItemFromRemote.swift
//  Farming Simulator 2022
//
//  Created by Sim on 26/09/24.
//

import SwiftUI

struct RemotePreviewItemController: View {
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @EnvironmentObject var dropBoxManager: DropBoxManagerModel_SimulatorFarm
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
        VStack(alignment: .leading, spacing: bigSize ? 24 : 16) {
            // Title at the top
            Text(titleData ?? "Name")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(FontTurboGear.gilroyStyle(size: bigSize ? 44 : 24, type: .bold))
                .foregroundStyle(ColorTurboGear.colorPicker(.darkGreen))
                .padding(.bottom, bigSize ? 24 : 8)
            
            // Image container with heart overlay
            Button {
                openDescriptionItem()
            } label: {
                ZStack(alignment: .topLeading) {
                    // Main image
                    RoundedRectangle(cornerRadius: bigSize ? 24 : 16)
                        .fill(Color.white)
                        .overlay {
                            ZStack {
                                if let imageData = imageData,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    ColorTurboGear.colorPicker(.grey)
                                    InfinityLoaderGreen()
                                        .frame(height: 55)
                                }
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: bigSize ? 24 : 16))
                    
                    // Heart button overlay
                    FavoriteButtonView(
                        stateFavoritHeart: $likeState,
                        onTapButton: tappedLikeButton
                    )
                    .padding(bigSize ? 16 : 12)
                }
            }
            .frame(maxHeight: bigSize ? 578 : 304)
            
            // Description text
            Text(previewText ?? "Description unavailable")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(FontTurboGear.gilroyStyle(size: bigSize ? 24 : 14, type: .regular))
                .foregroundStyle(ColorTurboGear.colorPicker(.darkGreen))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .padding(.top, bigSize ? 24 : 8)
        }
    }
}

#Preview {
    RemotePreviewItemController(imagePath: "", likeState: .constant(true), tappedLikeButton: {_ in}, openDescriptionItem: {}, sendBackImageData: {_ in})
}
