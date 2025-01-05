//
//  LoadingPreviewVMCyan.swift
//  Farming Simulator 2022
//
//  Created by Sim on 26/09/24.
//

import Foundation
import SwiftUI
import CoreData

//class LoadingPreviewVMCyan: ObservableObject {
//    @Published var progress: Int = 0
//    @Published var pauseType: Bool = false
//    private var timer: Timer?
//    let imageSaveToCoreDate: ImageLoader = ImageLoader()
//    @Published var loaderCount: Int = 0
//    @Published var countImageSaved: Int = 0
//    var allDataCount = 0
//    var counter: Int = 0
//}
//
//extension LoadingPreviewVMCyan {
//    func startLoadingPreviewKitchenToolUsage() {
//        timer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { [weak self] time in
//            guard let self = self else { return }
//            if self.pauseType == false {
//                if self.progress < 100 {
//                    self.progress += 1
//                } else {
//                    time.invalidate()
//                    self.progress = 0
//                }
//            }
//        }
//    }
//    
//    func addAllElementToCoreData(allData: FetchedResults<BodyElement>, dropBoxManager: DropBoxManager_SimulatorFarm, viewContext: NSManagedObjectContext) async {
//        if allData.isEmpty { return }
//        allDataCount = allData.count
//        await withTaskGroup(of: Void.self) { taskGroup in
//            var activeTasks = 0
//            let maxConcurrentTasks = 7
//
//            for item in allData {
//                counter += 1
//                if activeTasks >= maxConcurrentTasks {
//                    await taskGroup.next()
//                    activeTasks -= 1
//                    countDownloadedImages()
//                }
//                taskGroup.addTask {
//                    await self.downloadAndSaveImage(url: item.editImageString ?? "", urlPreview: item.previewImageString ?? "", dropBoxManager: dropBoxManager, viewContext: viewContext, element: item)
//                }
//                activeTasks += 1
//            }
//            
//            await taskGroup.waitForAll()
//        }
//        countDownloadedImages()
//        self.imageSaveToCoreDate.loadedCount = 0
//    }
//
//    func downloadAndSaveImage(url: String, urlPreview: String, dropBoxManager: DropBoxManager_SimulatorFarm, viewContext: NSManagedObjectContext, element: BodyElement) async {
//        if element.editroImage != nil && element.previewImage != nil {
//            self.imageSaveToCoreDate.loadedCount += 1
//            
//            return
//        }
//        guard let data = await dropBoxDownloadImage(preview: false, url: url, dropBoxManager: dropBoxManager) else { return }
//        guard let dataPreview = await dropBoxDownloadImage(preview: true, url: urlPreview, dropBoxManager: dropBoxManager) else { return }
//        await saveImageToCoreData(data: data, preview: dataPreview, viewContext: viewContext, element: element)
//    }
//
//    func dropBoxDownloadImage(preview: Bool, url: String, dropBoxManager: DropBoxManager_SimulatorFarm) async -> Data? {
//        let fullUrl = "\(DropBoxKeys_SimulatorFarm.bodyEditorImagePartPath)\(url)"
//        
//        return await withCheckedContinuation { continuation in
//            dropBoxManager.getData(from: fullUrl, isImage: true) { data in
//                continuation.resume(returning: data)
//            }
//        }
//    }
//
//    func saveImageToCoreData(data: Data, preview: Data, viewContext: NSManagedObjectContext, element: BodyElement) async {
//        imageSaveToCoreDate.loadImage(data, previewData: preview, context: viewContext, preview: true, element: element)
//        countDownloadedImages()
//    }
//    
//    func countDownloadedImages() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.loaderCount = self.imageSaveToCoreDate.loadedCount
//            let tempCalculate = Int(self.loaderCount * 100 / self.allDataCount)
//            if self.counter >= self.allDataCount {
//                self.progress = 100
//                self.counter = 0
//            } else if self.allDataCount > 0 && self.loaderCount < self.allDataCount {
//                if tempCalculate > self.progress && tempCalculate != self.progress {
//                    self.progress = tempCalculate
//                }
//            } else {
//                self.progress = 100
//            }
//        }
//    }
//}

//class LoadingPreviewVMCyan: ObservableObject {
//    @Published var progress: Int = 0
//    @Published var pauseType: Bool = false
//    @Published var loaderCount: Int = 0
//    @Published var countImageSaved: Int = 0
//    @Published var loadingError: String?
//    
//    var allDataCount = 0
//    var counter: Int = 0
//    private var timer: Timer?
//    let imageSaveToCoreDate: ImageLoader = ImageLoader()
//    
//    func startLoadingPreviewKitchenToolUsage() {
//        DispatchQueue.main.async {
//            self.timer?.invalidate()
//            self.timer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { [weak self] time in
//                guard let self = self else {
//                    time.invalidate()
//                    return
//                }
//                
//                if !self.pauseType {
//                    if self.progress < 100 {
//                        DispatchQueue.main.async {
//                            self.progress += 1
//                        }
//                    } else {
//                        time.invalidate()
//                        DispatchQueue.main.async {
//                            self.progress = 0
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func addAllElementToCoreData(allData: FetchedResults<BodyElement>, dropBoxManager: DropBoxManager_SimulatorFarm, viewContext: NSManagedObjectContext) async {
//        await MainActor.run {
//            self.progress = 0
//            self.loadingError = nil
//            self.loaderCount = 0
//            self.counter = 0
//        }
//        
//        guard !allData.isEmpty else {
//            print("No data to process - checking if data needs to be fetched")
//            // Trigger data fetch from DropBox if needed
//            dropBoxManager.validateAccesToken()
//            await MainActor.run {
//                self.progress = 100
//            }
//            return
//        }
//        
//        allDataCount = allData.count
//        print("Starting to process \(allDataCount) elements")
//        
//        await withTaskGroup(of: Void.self) { taskGroup in
//            var activeTasks = 0
//            let maxConcurrentTasks = 7
//
//            for item in allData {
//                await MainActor.run {
//                    self.counter += 1
//                }
//                
//                if activeTasks >= maxConcurrentTasks {
//                    await taskGroup.next()
//                    activeTasks -= 1
//                    await countDownloadedImages()
//                }
//                
//                taskGroup.addTask {
//                    await self.downloadAndSaveImage(
//                        url: item.editImageString ?? "",
//                        urlPreview: item.previewImageString ?? "",
//                        dropBoxManager: dropBoxManager,
//                        viewContext: viewContext,
//                        element: item
//                    )
//                }
//                activeTasks += 1
//            }
//            
//            await taskGroup.waitForAll()
//        }
//        
//        await countDownloadedImages()
//        
//        await MainActor.run {
//            self.imageSaveToCoreDate.loadedCount = 0
//            if self.loadingError == nil {
//                self.progress = 100
//            }
//        }
//    }
//
//    private func downloadAndSaveImage(url: String, urlPreview: String, dropBoxManager: DropBoxManager_SimulatorFarm, viewContext: NSManagedObjectContext, element: BodyElement) async {
//        if element.editroImage != nil && element.previewImage != nil {
//            await MainActor.run {
//                self.imageSaveToCoreDate.loadedCount += 1
//            }
//            return
//        }
//        
//        do {
//            async let mainData = dropBoxDownloadImage(preview: false, url: url, dropBoxManager: dropBoxManager)
//            async let previewData = dropBoxDownloadImage(preview: true, url: urlPreview, dropBoxManager: dropBoxManager)
//            
//            guard let data = await mainData,
//                  let previewData = await previewData else {
//                await MainActor.run {
//                    self.loadingError = "Failed to download images"
//                }
//                return
//            }
//            
//            await saveImageToCoreData(data: data, preview: previewData, viewContext: viewContext, element: element)
//            
//        } catch {
//            print("Error downloading/saving image: \(error)")
//            await MainActor.run {
//                self.loadingError = error.localizedDescription
//            }
//        }
//    }
//
//    private func dropBoxDownloadImage(preview: Bool, url: String, dropBoxManager: DropBoxManager_SimulatorFarm) async -> Data? {
//        let fullUrl = "\(DropBoxKeys_SimulatorFarm.bodyEditorImagePartPath)\(url)"
//        
//        return await withCheckedContinuation { continuation in
//            dropBoxManager.getData(from: fullUrl, isImage: true) { data in
//                continuation.resume(returning: data)
//            }
//        }
//    }
//
//    private func saveImageToCoreData(data: Data, preview: Data, viewContext: NSManagedObjectContext, element: BodyElement) async {
//        // Save on a background context
//        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        context.parent = viewContext
//        
//        await context.perform {
//            self.imageSaveToCoreDate.loadImage(data, previewData: preview, context: context, preview: true, element: element)
//            
//            do {
//                try context.save()
//                viewContext.performAndWait {
//                    try? viewContext.save()
//                }
//            } catch {
//                print("Error saving to CoreData: \(error)")
//            }
//        }
//        
//        await countDownloadedImages()
//    }
//    
//    private func countDownloadedImages() async {
//        await MainActor.run {
//            self.loaderCount = self.imageSaveToCoreDate.loadedCount
//            let tempCalculate = Int(self.loaderCount * 100 / self.allDataCount)
//            
//            if self.counter >= self.allDataCount {
//                self.progress = 100
//                self.counter = 0
//            } else if self.allDataCount > 0 && self.loaderCount < self.allDataCount {
//                if tempCalculate > self.progress && tempCalculate != self.progress {
//                    self.progress = tempCalculate
//                }
//            } else {
//                self.progress = 100
//            }
//        }
//    }
//}

class LoadingPreviewVMCyan: ObservableObject {
    @Published var progress: Int = 0
    @Published var pauseType: Bool = false
    @Published var loaderCount: Int = 0
    @Published var countImageSaved: Int = 0
    @Published var isLoading: Bool = false
    private var loadingQueue = DispatchQueue(label: "com.app.imageLoading", qos: .userInitiated)
    
    var allDataCount = 0
    var counter: Int = 0
    private var timer: Timer?
    let imageSaveToCoreDate: ImageLoader = ImageLoader()
    
    func addAllElementToCoreData(allData: FetchedResults<BodyElement>, dropBoxManager: DropBoxManager_SimulatorFarm, viewContext: NSManagedObjectContext) async {
        guard !allData.isEmpty else {
            progress = 100
            return
        }
        
        isLoading = true
        allDataCount = allData.count
        let batchSize = 5 // Process 5 images at a time
        
        for batch in stride(from: 0, to: allData.count, by: batchSize) {
            let endIndex = min(batch + batchSize, allData.count)
            let currentBatch = Array(allData[batch..<endIndex])
            
            await withTaskGroup(of: Void.self) { group in
                for item in currentBatch {
                    group.addTask {
                        await self.processElement(item, dropBoxManager: dropBoxManager, viewContext: viewContext)
                    }
                }
            }
            
            // Update progress after each batch
            DispatchQueue.main.async {
                self.counter += currentBatch.count
                self.updateProgress()
            }
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
            self.progress = 100
        }
    }
    
    private func processElement(_ element: BodyElement, dropBoxManager: DropBoxManager_SimulatorFarm, viewContext: NSManagedObjectContext) async {
        // Skip if already processed
        guard element.editroImage == nil || element.previewImage == nil else {
            DispatchQueue.main.async {
                self.loaderCount += 1
                self.updateProgress()
            }
            return
        }
        
        // Download images
        async let mainImage = downloadImage(url: element.editImageString ?? "", dropBoxManager: dropBoxManager)
        async let previewImage = downloadImage(url: element.previewImageString ?? "", dropBoxManager: dropBoxManager)
        
        guard let mainData = await mainImage,
              let previewData = await previewImage else {
            return
        }
        
        // Save to Core Data
        await MainActor.run {
            element.editroImage = mainData
            element.previewImage = previewData
            do {
                try viewContext.save()
                self.loaderCount += 1
                self.updateProgress()
            } catch {
                print("Error saving to Core Data: \(error)")
            }
        }
    }
    
    private func downloadImage(url: String, dropBoxManager: DropBoxManager_SimulatorFarm) async -> Data? {
        let fullUrl = "\(DropBoxKeys_SimulatorFarm.bodyEditorImagePartPath)\(url)"
        return await withCheckedContinuation { continuation in
            dropBoxManager.getData(from: fullUrl, isImage: true) { data in
                continuation.resume(returning: data)
            }
        }
    }
    
    func startLoadingPreviewKitchenToolUsage() {
            // Cancel any existing timer
            timer?.invalidate()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { [weak self] time in
                guard let self = self else {
                    time.invalidate()
                    return
                }
                
                if !self.pauseType {
                    if self.progress < 100 {
                        self.progress += 1
                    } else {
                        time.invalidate()
                    }
                }
            }
        }
        
        deinit {
            timer?.invalidate()
        }
    
    private func updateProgress() {
        let calculatedProgress = Int((Double(self.loaderCount) / Double(self.allDataCount)) * 100)
        if calculatedProgress > self.progress {
            self.progress = min(calculatedProgress, 99) // Keep at 99 until fully complete
        }
    }
}
