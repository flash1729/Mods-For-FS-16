//
//  AboutItemPageWithDownloadButton.swift
//  Farming Simulator 2022
//
//  Created by Sim on 27/09/24.
//

import Foundation
import SwiftUI
import MobileCoreServices

struct AboutItemPageWithDownloadButton: View {
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @State var titleItemName: String
    @State var favoriteState: Bool
    @State var imageData: Data?
    @State var linkDownloadItem: String?
    @State var textItem: String
    @State var navUpdateId: UUID = UUID()
    @State var saveState: IconTurboGear.SaveStateIconTurbo = .saveFailedIconElement
    @State var showSaveState: Bool = false
    @State var showSaveAlert: Bool = false
    @State var showDownloadProgress: Bool = false
    @State var progressDownload: Double = 0.0
    @State var idItemToLike: (Bool) -> ()
    @State var clearItemName: String
    @State var disableButton: Bool = false
    
    @State var workInternetState: Bool = true
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @State var timer: Timer?
    
    @EnvironmentObject var dropBoxManager: DropBoxManager_SimulatorFarm
    @State var isLoading: Bool = false
    @State var isFileDownloaded: Bool = false
    
    private func showShareSheet(withURL urlString: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let viewController = windowScene.windows.first?.rootViewController else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [URL(fileURLWithPath: urlString)], applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if #available(iOS 15.0, *) {
                let screenBounds = UIScreen.main.bounds
                let anchor = CGRect(x: screenBounds.width / 2, y: screenBounds.height, width: 0, height: 0)
                
                activityViewController.popoverPresentationController?.sourceRect = anchor
                activityViewController.popoverPresentationController?.sourceView = viewController.view
            } else {
                // iOS 14 and below
            }
        }
        
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            DispatchQueue.main.async {
                if success {
                    saveState = .saveSuccesfulIconElement
                    showSaveState = true
                } else {
                    saveState = .saveFailedIconElement
                    showSaveState = true
                }
                isLoading = false
            }
        }
        if let presentedVC = viewController.presentedViewController {
            presentedVC.dismiss(animated: true) {
                viewController.present(activityViewController, animated: true, completion: nil)
            }
        } else {
            viewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func makeMyURLString(from fileName: String) -> String {
        let fileArray = fileName.components(separatedBy: "/")
        
        return (try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(fileArray.last ?? "").path) ?? ""
        
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: bigSize ? 31 : 10) {
                NavPanelCyan(titleName: titleItemName, favoriteState: favoriteState, favoriteTapped: {bool in
                    idItemToLike(bool)
                })
                .id(navUpdateId)
                .padding(.bottom, bigSize ? 10 : 5)
                downloadSection
                    .paddingFlyBullet()
                
                imageSection
                    .paddingFlyBullet()
                    .padding(.top, bigSize ? 10 : 5)
                if !titleItemName.isEmpty || !textItem.isEmpty {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        textSection
                            .paddingFlyBullet()
                    }
                }
                Spacer()
                downloadButton
                    .paddingFlyBullet()
            }
            .ignoresSafeArea(.all, edges: .top)
            .frame(maxHeight: .infinity, alignment: .top)
            
            if showSaveAlert {
                SaveEditorAlert(stateTapped: {state in
                    if state {
                        PhotoLibraryManager.shared.saveToGallary(image: UIImage(data: imageData ?? Data()), saveCompletion: {error in
                            if error == nil {
                                saveState = .saveSuccesfulIconElement
                                showSaveState = true
                                showSaveAlert = false
                            } else {
                                saveState = .saveFailedIconElement
                                showSaveState = true
                                showSaveAlert = false
                            }
                        })
                    } else {
                        showSaveAlert.toggle()
                    }
                }, saveToHisory: true)
            }
            
            if !workInternetState {
                LostConnectElement {
                    workInternetState.toggle()
                }
            }
        }
        .onAppear(){
            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
        }
        .onDisappear(){
            timer?.invalidate()
        }
        .onChange(of: progressDownload) { newValue in
            if newValue >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.showDownloadProgress = false
                    self.disableButton = false
                })
            }
        }
    }
    
    private var imageSection: some View {
        RoundedRectangle(cornerRadius: bigSize ? 36 : 20)
            .fill(Color.white)
            .frame(maxHeight: bigSize ? (linkDownloadItem == nil ? 700 : 578) : (linkDownloadItem == nil ? 500 : 318))
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
    
    private var textSection: some View {
        VStack(alignment: .leading, spacing: bigSize ? 31 : 17) {
            Text(titleItemName)
                .font(FontTurboGear.montserratStyle(size: bigSize ? 33 : 18, type: .semibold))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            Text(textItem)
                .font(FontTurboGear.montserratStyle(size: bigSize ? 25 : 14, type: .regular))
        }
        .foregroundColor(.white)
    }
    
    private var downloadSection: some View {
        VStack {
            if showSaveState {
                SaveStateCustomView(saveState: $saveState)
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            self.showSaveState = false
                        })
                    }
            }
            if showDownloadProgress {
                DownloadLoadingProgressCyan(progressDownload: $progressDownload)
            }
        }
    }
    
    private var downloadButton: some View {
        VStack {
            if linkDownloadItem != nil {
                BlueButtonWithBorders(blueButtonTap: {
                    disableButton = true
                    guard networkManager.checkInternetConnectivity_SimulatorFarm() else {
                        workInternetState = false
                        disableButton = false
                        return
                    }
                    if FileManager.default.fileExists(atPath:makeMyURLString(from: clearItemName)) {
                        // Show the share sheet directly
                        progressDownload = 1.0
                        showShareSheet(withURL: makeMyURLString(from: clearItemName))
                        disableButton = false
                        return
                    }
                    isLoading = true
                    guard let fileName = linkDownloadItem else {return}
                    guard !fileName.isEmpty else {
                        print("Error: File name is empty")
                        
                        saveState = .saveFailedIconElement
                        showSaveState = true
                        
                        isLoading = false
                        disableButton = false
                        return
                    }
                    dropBoxManager.downloadFile_SimulatorFarm(fileName: fileName) { progressData in
                        showDownloadProgress = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                            let tempFile = (progressData.fractionCompleted * 100).rounded() / 100
                            progressDownload = tempFile
                        })
                    } completion: { downloadedData in
                        if let isFile = downloadedData {
                            
                            let downloadFile_SimulatorFarmname: String = fileName
                            let fileArray = downloadFile_SimulatorFarmname.components(separatedBy: "/")
                            let finalFileName = fileArray.last ?? ""
                            let fileManager = FileManager.default
                            
                            let docsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                            var myURLString = docsURL.appendingPathComponent(finalFileName).absoluteString
                            myURLString = myURLString.replacingOccurrences(of: "file://", with: "")
                            
                            fileManager.createFile(atPath: myURLString, contents: isFile, attributes: nil)
                            
                            if fileManager.fileExists(atPath: myURLString) {
                                print("File Exists at \(myURLString)")
                                
                                isFileDownloaded = true
                                progressDownload = 1.0
                                showShareSheet(withURL: myURLString)
                            } else {
                                print("File not found")
                                
                                saveState = .saveFailedIconElement
                                showSaveState = true
                                
                                isLoading = false
                            }
                        } else {
                            isLoading = false
                        }
                    }
                }, titleButton: "Download", infinityWidth: true)
                .padding(.bottom, bigSize ? 50 : 10)
                .disabled(disableButton)
                .opacity(disableButton ? 0.5 : 1.0)
            } else {
                BlueButtonWithBorders(blueButtonTap: {
                    showSaveAlert = true
                }, titleButton: "Download", infinityWidth: true)
                .padding(.bottom, bigSize ? 50 : 10)
            }
        }
    }
    
}

#Preview {
    AboutItemPageWithDownloadButton(titleItemName: "Name", favoriteState: true, textItem: "Test text", idItemToLike: {_ in}, clearItemName: "")
}
