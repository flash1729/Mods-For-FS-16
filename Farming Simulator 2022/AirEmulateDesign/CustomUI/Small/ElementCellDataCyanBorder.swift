//
//  ElementCellDataCyanBorder.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct ElementCellDataCyanBorder: View {
    @EnvironmentObject var dropBoxManager: DropBoxManager_SimulatorFarm
    @State private var isInternetAvailable = true
    @ObservedObject var networkManager = NetworkManager_SimulatorFarm()
    @State var imageName: String
    @Binding var choosedImageName: String
    @State var tappedOnImage: () -> Void
    @State var imageData: Data? = nil
    @State var sendBackImageData: (Data) -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    @State var timer: Timer?
    var body: some View {
        Button {
            choosedImageName = imageName
            tappedOnImage()
        } label: {
            RoundedRectangle(cornerRadius: bigSize ? 36 : 20)
                .fill(Color.white)
                .overlay {
                    ZStack {
                        if let imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            ZStack {
                                ColorTurboGear.colorPicker(.darkGray)
                                InfinityLoaderCyan()
                                    .frame(height: 55)
                            }
                            .onAppear {
                                if imageData == nil && networkManager.checkInternetConnectivity_SimulatorFarm() {
                                    if dropBoxManager.validateDropToken {
                                        timer?.invalidate()
                                        dropBoxManager.getData(from: imageName, isImage: true, completion: { data in
                                            Task {
                                                await MainActor.run {
                                                    self.imageData = data
                                                    if let data {
                                                        sendBackImageData(data)
                                                    }
                                                }
                                            }
                                        })
                                    } else {
                                        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                                            dropBoxManager.validateAccesToken()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .overlay(content: {
                    RoundedRectangle(cornerRadius: bigSize ? 36 : 20)
                        .strokeBorder(imageName == choosedImageName ? ColorTurboGear.colorPicker(.cyan) : Color.clear, lineWidth: bigSize ? 5 : 3, antialiased: true)
                })
                .clipShape(RoundedRectangle(cornerRadius: bigSize ? 36 : 20))
                .contentShape(RoundedRectangle(cornerRadius: bigSize ? 36 : 20))
                .frame(width: bigSize ? 180 : 100, height: bigSize ? 180 : 100)
                .onAppear {
                    isInternetAvailable = networkManager.checkInternetConnectivity_SimulatorFarm()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    isInternetAvailable = networkManager.checkInternetConnectivity_SimulatorFarm()
                }
        }

    }
}

#Preview {
    ElementCellDataCyanBorder(imageName: IconTurboGear.mediumRareBackToPhone, choosedImageName: .constant(IconTurboGear.mediumRareBackToPhone), tappedOnImage: {}, sendBackImageData: {_ in})
}
