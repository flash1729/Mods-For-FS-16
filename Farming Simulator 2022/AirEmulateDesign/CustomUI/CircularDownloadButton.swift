//
//  CircularDownloadButton.swift
//  Farming Simulator 2022
//
//  Created by Aditya Medhane on 28/12/24.
//

import SwiftUI

enum DownloadState{
    case initial
    case downloading(progress: Double)
    case success
    case failure
}

struct CircularDownloadButton: View {
    // Core download properties
    @State private var downloadState: DownloadState = .initial
    @Binding var progressDownload: Double
    let linkDownloadItem: String?
    let clearItemName: String
    
    // State management
    @State private var isLoading: Bool = false
    @State private var isFileDownloaded: Bool = false
    
    // Environment objects
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @EnvironmentObject private var dropBoxManager: DropBoxManager_SimulatorFarm
    
    // Constants
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    private let successDisplayDuration: TimeInterval = 1.5
    
    var body: some View {
        Button {
            handleDownload()
        } label: {
            Group {
                switch downloadState {
                case .initial:
                    Image("downloadButtonGreen")
                        .resizable()
                        .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                
                case .downloading(let progress):
                    ZStack {
                        Circle()
                            .stroke(
                                Color.gray.opacity(0.3),
                                lineWidth: 3
                            )
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(progress))
                            .stroke(
                                ColorTurboGear.colorPicker(.darkGreen),
                                style: StrokeStyle(
                                    lineWidth: 3,
                                    lineCap: .round
                                )
                            )
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(Int(progress * 100))%")
                            .font(FontTurboGear.gilroyStyle(size: 12, type: .medium))
                            .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                    }
                    .frame(width: 44, height: 44)
                
                case .success:
                    Image("downCompleteIcon")
                        .resizable()
                        .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                        .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                
                case .failure:
                    Image("downFailIcon")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
                }
            }
        }
        .disabled({
            switch downloadState {
            case .initial: return isLoading
            case .downloading, .success, .failure: return true
            }
        }())
    }
    
    private func handleDownload() {
        guard let fileName = linkDownloadItem, !fileName.isEmpty else {
            handleFailure()
            return
        }
        
        // Check network connectivity
        guard networkManager.checkInternetConnectivity_SimulatorFarm() else {
            handleFailure()
            return
        }
        
        // Check if file already exists
        if FileManager.default.fileExists(atPath: makeMyURLString(from: clearItemName)) {
            progressDownload = 1.0
            showShareSheet(withURL: makeMyURLString(from: clearItemName))
            return
        }
        
        // Start download
        isLoading = true
        downloadState = .downloading(progress: 0)
        
        dropBoxManager.downloadFile_SimulatorFarm(fileName: fileName) { progressData in
            DispatchQueue.main.async {
                let progress = (progressData.fractionCompleted * 100).rounded() / 100
                progressDownload = progress
                downloadState = .downloading(progress: progress)
            }
        } completion: { downloadedData in
            handleDownloadCompletion(downloadedData, fileName: fileName)
        }
    }
    
    private func handleDownloadCompletion(_ downloadedData: Data?, fileName: String) {
        guard let fileData = downloadedData else {
            handleFailure()
            return
        }
        
        let fileArray = fileName.components(separatedBy: "/")
        let finalFileName = fileArray.last ?? ""
        let fileManager = FileManager.default
        
        do {
            let docsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            var myURLString = docsURL.appendingPathComponent(finalFileName).absoluteString
            myURLString = myURLString.replacingOccurrences(of: "file://", with: "")
            
            fileManager.createFile(atPath: myURLString, contents: fileData, attributes: nil)
            
            if fileManager.fileExists(atPath: myURLString) {
                isFileDownloaded = true
                progressDownload = 1.0
                handleSuccess()
                showShareSheet(withURL: myURLString)
            } else {
                handleFailure()
            }
        } catch {
            handleFailure()
        }
    }
    
    private func handleSuccess() {
        downloadState = .success
        resetStateAfterDelay()
    }
    
    private func handleFailure() {
        downloadState = .failure
        isLoading = false
        resetStateAfterDelay()
    }
    
    private func resetStateAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + successDisplayDuration) {
            downloadState = .initial
            isLoading = false
        }
    }
    
    private func makeMyURLString(from fileName: String) -> String {
        let fileArray = fileName.components(separatedBy: "/")
        return (try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(fileArray.last ?? "").path) ?? ""
    }
    
    private func showShareSheet(withURL urlString: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let viewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: [URL(fileURLWithPath: urlString)],
            applicationActivities: nil
        )
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if #available(iOS 15.0, *) {
                let screenBounds = UIScreen.main.bounds
                activityViewController.popoverPresentationController?.sourceRect = CGRect(
                    x: screenBounds.width / 2,
                    y: screenBounds.height,
                    width: 0,
                    height: 0
                )
                activityViewController.popoverPresentationController?.sourceView = viewController.view
            }
        }
        
        activityViewController.completionWithItemsHandler = { (_, success, _, _) in
            DispatchQueue.main.async {
                if success {
                    handleSuccess()
                } else {
                    handleFailure()
                }
                isLoading = false
            }
        }
        
        if let presentedVC = viewController.presentedViewController {
            presentedVC.dismiss(animated: true) {
                viewController.present(activityViewController, animated: true)
            }
        } else {
            viewController.present(activityViewController, animated: true)
        }
    }
}

// MARK: - Preview Provider
struct CircularDownloadButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Initial state
            CircularDownloadButton(
                progressDownload: .constant(0),
                linkDownloadItem: "sample/path",
                clearItemName: "sample"
            )
            
            // Downloading state
            CircularDownloadButton(
                progressDownload: .constant(0.45),
                linkDownloadItem: "sample/path",
                clearItemName: "sample"
            )
            
            // Success state
            CircularDownloadButton(
                progressDownload: .constant(1),
                linkDownloadItem: "sample/path",
                clearItemName: "sample"
            )
            
            // Failure state
            CircularDownloadButton(
                progressDownload: .constant(0),
                linkDownloadItem: "sample/path",
                clearItemName: "sample"
            )
        }
        .padding()
        .environmentObject(NetworkManager_SimulatorFarm())
        .environmentObject(DropBoxManager_SimulatorFarm.shared)
    }
}
