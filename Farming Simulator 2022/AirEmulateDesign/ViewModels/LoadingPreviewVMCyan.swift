//
//  LoadingPreviewVMCyan.swift
//  Farming Simulator 2022
//
//  Created by Sim on 26/09/24.
//

import Foundation
import SwiftUI
import CoreData

class LoadingPreviewVMCyan: ObservableObject {
    @Published var progress: Int = 0
    @Published var pauseType: Bool = false
    private var timer: Timer?
    let imageSaveToCoreDate: ImageLoader = ImageLoader()
    @Published var loaderCount: Int = 0
    @Published var countImageSaved: Int = 0
    var allDataCount = 0
    var counter: Int = 0
}
extension LoadingPreviewVMCyan {
    func startLoadingPreviewKitchenToolUsage() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { [weak self] time in
            guard let self = self else { return }
            if self.pauseType == false {
                if self.progress < 100 {
                    self.progress += 1
                } else {
                    time.invalidate()
                    self.progress = 0
                }
            }
        }
    }
    
    func addAllElementToCoreData(allData: FetchedResults<BodyElement>, dropBoxManager: DropBoxManager_SimulatorFarm, viewContext: NSManagedObjectContext) async {
        if allData.isEmpty { return }
        allDataCount = allData.count
        await withTaskGroup(of: Void.self) { taskGroup in
            var activeTasks = 0
            let maxConcurrentTasks = 7

            for item in allData {
                counter += 1
                if activeTasks >= maxConcurrentTasks {
                    await taskGroup.next()
                    activeTasks -= 1
                    countDownloadedImages()
                }
                taskGroup.addTask {
                    await self.downloadAndSaveImage(url: item.editImageString ?? "", urlPreview: item.previewImageString ?? "", dropBoxManager: dropBoxManager, viewContext: viewContext, element: item)
                }
                activeTasks += 1
            }
            
            await taskGroup.waitForAll()
        }
        countDownloadedImages()
        self.imageSaveToCoreDate.loadedCount = 0
    }

    func downloadAndSaveImage(url: String, urlPreview: String, dropBoxManager: DropBoxManager_SimulatorFarm, viewContext: NSManagedObjectContext, element: BodyElement) async {
        if element.editroImage != nil && element.previewImage != nil {
            self.imageSaveToCoreDate.loadedCount += 1
            
            return
        }
        guard let data = await dropBoxDownloadImage(preview: false, url: url, dropBoxManager: dropBoxManager) else { return }
        guard let dataPreview = await dropBoxDownloadImage(preview: true, url: urlPreview, dropBoxManager: dropBoxManager) else { return }
        await saveImageToCoreData(data: data, preview: dataPreview, viewContext: viewContext, element: element)
    }

    func dropBoxDownloadImage(preview: Bool, url: String, dropBoxManager: DropBoxManager_SimulatorFarm) async -> Data? {
        let fullUrl = "\(DropBoxKeys_SimulatorFarm.bodyEditorImagePartPath)\(url)"
        
        return await withCheckedContinuation { continuation in
            dropBoxManager.getData(from: fullUrl, isImage: true) { data in
                continuation.resume(returning: data)
            }
        }
    }

    func saveImageToCoreData(data: Data, preview: Data, viewContext: NSManagedObjectContext, element: BodyElement) async {
        imageSaveToCoreDate.loadImage(data, previewData: preview, context: viewContext, preview: true, element: element)
        countDownloadedImages()
    }
    
    func countDownloadedImages() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.loaderCount = self.imageSaveToCoreDate.loadedCount
            let tempCalculate = Int(self.loaderCount * 100 / self.allDataCount)
            if self.counter >= self.allDataCount {
                self.progress = 100
                self.counter = 0
            } else if self.allDataCount > 0 && self.loaderCount < self.allDataCount {
                if tempCalculate > self.progress && tempCalculate != self.progress {
                    self.progress = tempCalculate
                }
            } else {
                self.progress = 100
            }
        }
    }
}
