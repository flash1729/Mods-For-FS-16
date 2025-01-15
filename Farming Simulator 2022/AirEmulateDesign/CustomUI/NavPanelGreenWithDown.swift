//
//  NavPanelCyan.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct NavPanelGreenWithDown: View {
    @Environment(\.dismiss) var dismiss
    
    // Existing parameters
    @State var titleName: String
    @State var favoriteState: Bool
    @State var favoriteTapped: (Bool) -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    // New parameters needed for CircularDownloadButton
    @State private var progressDownload: Double = 0.0
    let linkDownloadItem: String?           // Optional because some items might not have downloads
    let clearItemName: String
    
    // Environment objects needed for download functionality
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @EnvironmentObject private var dropBoxManager: DropBoxManagerModel_SimulatorFarm
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("backButtonGreen")
                        .resizable()
                        .scaledToFit()
                        .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                }
                
                Text(titleName)
                    .font(FontTurboGear.gilroyStyle(size: bigSize ? 44 : 24, type: .bold))
                    .foregroundStyle(ColorTurboGear.colorPicker(.green))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Spacer()
                
                // Add CircularDownloadButton here
                if linkDownloadItem != nil {
                    DownloadButtonWithProgressController(
                        progressDownload: $progressDownload,
                        linkDownloadItem: linkDownloadItem,
                        clearItemName: clearItemName
                    )
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .foregroundColor(.white)
        .paddingFlyBullet()
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .bottom)
        .frame(height: bigSize ? 137 : 128)
        .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
    }
}

// Updated preview provider to include the new required parameters
#Preview {
    NavPanelGreenWithDown(
        titleName: "Name",
        favoriteState: true,
        favoriteTapped: {_ in},
        linkDownloadItem: "sample/path",  // Add sample download path
        clearItemName: "sample"           // Add sample clear name
    )
    .environmentObject(NetworkManager_SimulatorFarm())        // Provide required environment objects
    .environmentObject(DropBoxManagerModel_SimulatorFarm.shared)   // for the preview
}
