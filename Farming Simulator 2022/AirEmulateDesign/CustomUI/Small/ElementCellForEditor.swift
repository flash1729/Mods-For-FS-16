//
//  ElementCellForEditor.swift
//  Farming Simulator 2022
//
//  Created by Sim on 14/10/24.
//

import SwiftUI

struct ElementCellForEditor: View {
    @EnvironmentObject var dropBoxManager: DropBoxManager_SimulatorFarm
    @State private var isInternetAvailable = true
    @ObservedObject var networkManager = NetworkManager_SimulatorFarm()
    @State var imageName: String
    @Binding var choosedImageName: String
    @State var tappedOnImage: () -> Void
    @State var imageData: Data? = nil
    @State var sendBackImageData: (Data) -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var index: Int
    @Binding var choosedIndex: Int
    @State var timer: Timer?
    @State var onlyWhiteElement: Bool = false
    @Binding var showInternetAlert: Bool
    var body: some View {
        Button {
            choosedImageName = imageName
            tappedOnImage()
        } label: {
            RoundedRectangle(cornerRadius: bigSize ? 36 : 20)
                .fill(Color.white)
                .overlay {
                    ZStack {
                        if onlyWhiteElement {
                            Color.white
                        } else {
                            if let imageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
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
                                            let fullUrl = "\(DropBoxKeys_SimulatorFarm.bodyEditorImagePartPath)\(imageName)"
                                            dropBoxManager.getData(from: fullUrl, isImage: true, completion: { data in
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
                }
                .overlay(content: {
                    RoundedRectangle(cornerRadius: bigSize ? 36 : 20)
                        .strokeBorder(index == choosedIndex ? ColorTurboGear.colorPicker(.cyan) : Color.clear, lineWidth: bigSize ? 5 : 3, antialiased: true)
                })
                .clipShape(RoundedRectangle(cornerRadius: bigSize ? 36 : 20))
                .contentShape(RoundedRectangle(cornerRadius: bigSize ? 36 : 20))
                .frame(width: bigSize ? 180 : 100, height: bigSize ? 180 : 100)
                .onAppear {
                    isInternetAvailable = networkManager.checkInternetConnectivity_SimulatorFarm()
                    if index == choosedIndex {
                        choosedImageName = imageName
                    }
                }
                .onChange(of: choosedIndex, perform: { newValue in
                    if index == choosedIndex {
                        choosedImageName = imageName
                    }
                })
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    isInternetAvailable = networkManager.checkInternetConnectivity_SimulatorFarm()
                }
        }

    }
}

//#Preview {
//    ElementCellForEditor()
//}
