//
//  PhotoLibraryManager.swift
//  Farming Simulator 2022
//
//  Created by Sim on 30/09/24.
//

import Foundation
import UIKit
import Photos

final class PhotoLibraryManager {
    static let shared = PhotoLibraryManager()
    
    private func requestPhotoLibraryPermission(completion: @escaping (Bool, String?) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .authorized, .limited:
            completion(true, nil)
        case .denied, .restricted:
            completion(false, "Acces denied")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        completion(true, nil)
                    } else {
                        completion(false, "Acces denied")
                    }
                }
            }
        @unknown default:
            completion(false, "Acces denied")
        }
    }
    
    func saveToGallary(image: UIImage?, saveCompletion: @escaping (String?) -> Void) {
        if let image {
            requestPhotoLibraryPermission { state, error in
                if state {
                    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                    saveCompletion(nil)
                } else {
                    saveCompletion(error)
                }
            }
        }
    }
}
