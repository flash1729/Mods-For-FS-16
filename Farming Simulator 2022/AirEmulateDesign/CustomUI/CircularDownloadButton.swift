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
    
//    private func handleDownloadCompletion(_ downloadedData: Data?, fileName: String) {
//        // Ensure we have downloaded data
//        guard let fileData = downloadedData else {
//            handleFailure()
//            return
//        }
//        
//        // Extract file extension and filename
//        let fileExtension = fileName.components(separatedBy: ".").last?.lowercased()
//        let fileArray = fileName.components(separatedBy: "/")
//        let finalFileName = fileArray.last ?? ""
//        
//        // Specifically handle PNG files
//        if fileExtension == "png" {
//            // Attempt to create UIImage from the downloaded data
//            guard let image = UIImage(data: fileData) else {
//                handleFailure()
//                return
//            }
//            
//            // Save image to photo library
//            UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
//        } else {
//            // For non-PNG files, use standard file saving approach
//            let fileManager = FileManager.default
//            
//            do {
//                // Get documents directory URL
//                let docsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                
//                // Create full file URL
//                let fileURL = docsURL.appendingPathComponent(finalFileName)
//                
//                // Write file data
//                try fileData.write(to: fileURL)
//                
//                // Verify file was saved
//                if fileManager.fileExists(atPath: fileURL.path) {
//                    isFileDownloaded = true
//                    progressDownload = 1.0
//                    handleSuccess()
//                    showShareSheet(withURL: fileURL.path)
//                } else {
//                    handleFailure()
//                }
//            } catch {
//                // Log any file system errors
//                print("File saving error: \(error.localizedDescription)")
//                handleFailure()
//            }
//        }
//    }
    
//    private func handleDownloadCompletion(_ downloadedData: Data?, fileName: String) {
//        guard let fileData = downloadedData else {
//            handleFailure()
//            return
//        }
//        
//        let fileExtension = fileName.components(separatedBy: ".").last?.lowercased()
//        
//        if fileExtension == "jpg" || fileExtension == "png" {
//               // Handle image files (wallpapers)
//               guard let image = UIImage(data: fileData) else {
//                   handleFailure()
//                   return
//               }
//               
//               UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//               
//               if let error = ImageIO.getCGImageSourceStatus(image.cgImage) {
//                   print("Error saving image: \(error.localizedDescription)")
//                   handleFailure()
//               } else {
//                   handleSuccess()
//               }
//           }    else {
//            // Handle non-image files (.mod files)
//            let fileArray = fileName.components(separatedBy: "/")
//            let finalFileName = fileArray.last ?? ""
//            let fileManager = FileManager.default
//            
//            do {
//                let docsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                var myURLString = docsURL.appendingPathComponent(finalFileName).absoluteString
//                myURLString = myURLString.replacingOccurrences(of: "file://", with: "")
//                
//                fileManager.createFile(atPath: myURLString, contents: fileData, attributes: nil)
//                
//                if fileManager.fileExists(atPath: myURLString) {
//                    isFileDownloaded = true
//                    progressDownload = 1.0
//                    handleSuccess()
//                    showShareSheet(withURL: myURLString)
//                } else {
//                    handleFailure()
//                }
//            } catch {
//                handleFailure()
//            }
//        }
//    }
    
//    private func handleDownloadCompletion(_ downloadedData: Data?, fileName: String) {
//        guard let fileData = downloadedData else {
//            handleFailure()
//            return
//        }
//        
//        let fileExtension = fileName.components(separatedBy: ".").last?.lowercased()
//        
//        if fileExtension == "jpg" || fileExtension == "png" {
//            // Handle image files (wallpapers)
//            guard let image = UIImage(data: fileData) else {
//                handleFailure()
//                return
//            }
//            
//            // Save the image to the Photos album
//            UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
//        } else {
//            // Handle non-image files (.mod files or others)
//            let fileArray = fileName.components(separatedBy: "/")
//            let finalFileName = fileArray.last ?? ""
//            let fileManager = FileManager.default
//            
//            do {
//                let docsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                let fileURL = docsURL.appendingPathComponent(finalFileName)
//                
//                try fileData.write(to: fileURL)
//                
//                if fileManager.fileExists(atPath: fileURL.path) {
//                    isFileDownloaded = true
//                    progressDownload = 1.0
//                    handleSuccess()
//                    showShareSheet(withURL: fileURL.path)
//                } else {
//                    handleFailure()
//                }
//            } catch {
//                print("Error saving file: \(error.localizedDescription)")
//                handleFailure()
//            }
//        }
//    }

//    // Add the @objc method for handling image save completion
//    @objc private func imageSaveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        if let error = error {
//            print("Error saving image: \(error.localizedDescription)")
//            handleFailure()
//        } else {
//            handleSuccess()
//        }
//    }

    private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
            handleFailure()
        } else {
            handleSuccess()
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

//final class CircularDownloadButton: NSObject, View {
//    // Existing properties with added clarity
//    @State private var downloadState: DownloadState = .initial
//    @Binding var progressDownload: Double
//    var linkDownloadItem: String? = nil
//    var clearItemName: String = ""
//    
//    // Environment objects for network and file management
//    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
//    @EnvironmentObject private var dropBoxManager: DropBoxManager_SimulatorFarm
//    
//    // State management properties
//    @State private var isLoading: Bool = false
//    @State private var isFileDownloaded: Bool = false
//    
//    // Constants and device-specific sizing
//    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
//    private let successDisplayDuration: TimeInterval = 1.5
//    
//    init(progressDownload: Binding<Double>,
//         linkDownloadItem: String? = nil,
//         clearItemName: String = "") {
//        self._progressDownload = progressDownload
//        self.linkDownloadItem = linkDownloadItem
//        self.clearItemName = clearItemName
//        super.init()
//    }
//
//    // Main download handling method
//    private func handleDownload() {
//        // 1. Validate download item
//        guard let fileName = linkDownloadItem, !fileName.isEmpty else {
//            handleFailure()
//            return
//        }
//        
//        // 2. Check network connectivity
//        guard networkManager.checkInternetConnectivity_SimulatorFarm() else {
//            handleFailure()
//            return
//        }
//        
//        // 3. Check if file already exists
//        if FileManager.default.fileExists(atPath: makeMyURLString(from: clearItemName)) {
//            progressDownload = 1.0
//            showShareSheet(withURL: makeMyURLString(from: clearItemName))
//            return
//        }
//        
//        // 4. Start download process
//        isLoading = true
//        downloadState = .downloading(progress: 0)
//        
//        dropBoxManager.downloadFile_SimulatorFarm(
//            fileName: fileName,
//            progressHandler: { [weak self] progressData in
//                // Update download progress
//                DispatchQueue.main.async {
//                    guard let self = self else { return }
//                    let progress = (progressData.fractionCompleted * 100).rounded() / 100
//                    self.progressDownload = progress
//                    self.downloadState = .downloading(progress: progress)
//                }
//            },
//            completion: { [weak self] downloadedData in
//                // Handle download completion
//                self?.handleDownloadCompletion(downloadedData, fileName: fileName)
//            }
//        )
//    }
//
//    // Comprehensive download completion handler
//    private func handleDownloadCompletion(_ downloadedData: Data?, fileName: String) {
//        // 1. Validate downloaded data
//        guard let fileData = downloadedData else {
//            handleFailure()
//            return
//        }
//        
//        // 2. Determine file type
//        let fileExtension = fileName.components(separatedBy: ".").last?.lowercased()
//        let fileArray = fileName.components(separatedBy: "/")
//        let finalFileName = fileArray.last ?? ""
//        
//        // 3. Handle different file types
//        if fileExtension == "png" || fileExtension == "jpg" {
//            // Image handling
//            handleImageDownload(imageData: fileData)
//        } else {
//            // File handling
//            handleFileDownload(fileData: fileData, fileName: finalFileName)
//        }
//    }
//    
//    // Specialized image download handling
//    private func handleImageDownload(imageData: Data) {
//        guard let image = UIImage(data: imageData) else {
//            handleFailure()
//            return
//        }
//        
//        // Save image to photo library
//        UIImageWriteToSavedPhotosAlbum(
//            image,
//            self,
//            #selector(imageSaveCompletion(_:didFinishSavingWithError:contextInfo:)),
//            nil
//        )
//    }
//    
//    // Specialized file download handling
//    private func handleFileDownload(fileData: Data, fileName: String) {
//        let fileManager = FileManager.default
//        
//        do {
//            // Get documents directory
//            let docsURL = try fileManager.url(
//                for: .documentDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: false
//            )
//            
//            // Create file URL
//            let fileURL = docsURL.appendingPathComponent(fileName)
//            
//            // Write file data
//            try fileData.write(to: fileURL)
//            
//            // Verify file was saved
//            if fileManager.fileExists(atPath: fileURL.path) {
//                isFileDownloaded = true
//                progressDownload = 1.0
//                handleSuccess()
//                showShareSheet(withURL: fileURL.path)
//            } else {
//                handleFailure()
//            }
//        } catch {
//            print("File saving error: \(error.localizedDescription)")
//            handleFailure()
//        }
//    }
//    
//    // Objective-C compatible image save completion handler
//    @objc private func imageSaveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        DispatchQueue.main.async {
//            if let error = error {
//                print("Image save error: \(error.localizedDescription)")
//                self.handleFailure()
//            } else {
//                self.progressDownload = 1.0
//                self.handleSuccess()
//            }
//        }
//    }
//    
//    // Share sheet method similar to previous implementation
//    private func showShareSheet(withURL urlString: String) {
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let viewController = windowScene.windows.first?.rootViewController else {
//            return
//        }
//        
//        let activityViewController = UIActivityViewController(
//            activityItems: [URL(fileURLWithPath: urlString)],
//            applicationActivities: nil
//        )
//        
//        // iPad-specific configuration
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            if #available(iOS 15.0, *) {
//                let screenBounds = UIScreen.main.bounds
//                activityViewController.popoverPresentationController?.sourceRect = CGRect(
//                    x: screenBounds.width / 2,
//                    y: screenBounds.height,
//                    width: 0,
//                    height: 0
//                )
//                activityViewController.popoverPresentationController?.sourceView = viewController.view
//            }
//        }
//        
//        // Completion handler
//        activityViewController.completionWithItemsHandler = { [weak self] (_, success, _, _) in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                success ? self.handleSuccess() : self.handleFailure()
//                self.isLoading = false
//            }
//        }
//        
//        // Present share sheet
//        if let presentedVC = viewController.presentedViewController {
//            presentedVC.dismiss(animated: true) {
//                viewController.present(activityViewController, animated: true)
//            }
//        } else {
//            viewController.present(activityViewController, animated: true)
//        }
//    }
//    
//    // Existing utility methods like makeMyURLString, handleSuccess, handleFailure, etc.
//    
//    private func makeMyURLString(from fileName: String) -> String {
//            let fileArray = fileName.components(separatedBy: "/")
//            
//            return (try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                .appendingPathComponent(fileArray.last ?? "").path) ?? ""
//        }
//
//        // Success state handler
//        private func handleSuccess() {
//            // Update download state to success
//            downloadState = .success
//            
//            // Reset state after a brief display
//            resetStateAfterDelay()
//        }
//
//        // Failure state handler
//        private func handleFailure() {
//            // Update download state to failure
//            downloadState = .failure
//            
//            // Reset loading state
//            isLoading = false
//            
//            // Reset state after a brief display
//            resetStateAfterDelay()
//        }
//
//        // State reset method
//        private func resetStateAfterDelay() {
//            // Asynchronously reset to initial state after showing result
//            DispatchQueue.main.asyncAfter(deadline: .now() + successDisplayDuration) {
//                self.downloadState = .initial
//                self.isLoading = false
//            }
//        }
//
//        // SwiftUI body implementation
//        var body: some View {
//            Button {
//                self.handleDownload()
//            } label: {
//                Group {
//                    switch downloadState {
//                    case .initial:
//                        // Initial state: show download button
//                        Image("downloadButtonGreen")
//                            .resizable()
//                            .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
//                    
//                    case .downloading(let progress):
//                        // Downloading state: show progress circle
//                        ZStack {
//                            Circle()
//                                .stroke(
//                                    Color.gray.opacity(0.3),
//                                    lineWidth: 3
//                                )
//                            
//                            Circle()
//                                .trim(from: 0, to: CGFloat(progress))
//                                .stroke(
//                                    ColorTurboGear.colorPicker(.darkGreen),
//                                    style: StrokeStyle(
//                                        lineWidth: 3,
//                                        lineCap: .round
//                                    )
//                                )
//                                .rotationEffect(.degrees(-90))
//                            
//                            Text("\(Int(progress * 100))%")
//                                .font(FontTurboGear.gilroyStyle(size: 12, type: .medium))
//                                .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
//                        }
//                        .frame(width: 44, height: 44)
//                    
//                    case .success:
//                        // Success state: show completion icon
//                        Image("downCompleteIcon")
//                            .resizable()
//                            .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
//                            .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
//                    
//                    case .failure:
//                        // Failure state: show error icon
//                        Image("downFailIcon")
//                            .resizable()
//                            .foregroundColor(.red)
//                            .frame(width: bigSize ? 80 : 44, height: bigSize ? 80 : 44)
//                    }
//                }
//            }
//            .disabled({
//                // Disable button based on current state
//                switch downloadState {
//                case .initial: return isLoading
//                case .downloading, .success, .failure: return true
//                }
//            }())
//        }
//}
