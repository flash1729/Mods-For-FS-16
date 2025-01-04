//
//  DropBoxManager.swift
//  Farming Simulator 2022
//
//  Created by Systems
//

import Foundation
import SwiftUI
import SwiftyDropbox
import Combine
import CoreData

class DropBoxManager_SimulatorFarm: ObservableObject {
    static let shared = DropBoxManager_SimulatorFarm()
    
    private var coreDataHelper = PersistenceController.shared
    private var client: DropboxClient?
    
    @AppStorage("skinsDataCount") private var skinsDataCount = 0
    @AppStorage("mapsDataCount") private var mapsDataCount = 0
    @AppStorage("modsDataCount") private var modsDataCount = 0
    @AppStorage("farmsDataCount") private var farmsDataCount = 0
    @AppStorage("nicknameDataCount") private var nicknameDataCount = 0
    @AppStorage("bodyEditorDataCount") private var bodyEditorDataCount = 0
    var validateDropToken: Bool = false
    
    @Published private(set) var progress = 0
    
    private var firstInternetConnection: Bool = true
    
    private init() { }
    
    func initialize_FarmSimulator() {
//        clearAll_SimulatorFarm()
        Task {
            do {
                try await validateAccessToken(DropBoxKeys_SimulatorFarm.refresh_token)
                await fetchData_SimulatorFarm()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    private func clearAll_SimulatorFarm() {
        skinsDataCount = 0
        mapsDataCount = 0
        modsDataCount = 0
        farmsDataCount = 0
        nicknameDataCount = 0
        bodyEditorDataCount = 0
        coreDataHelper.deleteAll_FarmsAndModsAndMaps()
    }

    private func fetchData_SimulatorFarm() async {
        fetchSkins_SimulatorFarm()
        fetchMaps_SimulatorFarm()
        fetchMods_SimulatorFarm()
        fetchFarms_SimulatorFarm()

        fetchBodyEditor_SimulatorFarm()
    }
    
    func validateAccesToken() {
        Task {
            do {
                try await validateAccessToken(DropBoxKeys_SimulatorFarm.refresh_token)
                await fetchDataLocal()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func fetchDataLocal() async {
        if mapsDataCount == 0 || modsDataCount == 0 || farmsDataCount == 0 || skinsDataCount == 0 || nicknameDataCount == 0 || bodyEditorDataCount == 0 {
            firstInternetConnection = true
        }
        if firstInternetConnection {
            fetchSkins_SimulatorFarm()
            fetchMaps_SimulatorFarm()
            fetchMods_SimulatorFarm()
            fetchFarms_SimulatorFarm()
            
            fetchBodyEditor_SimulatorFarm()
            
            firstInternetConnection = false
        }
    }
    
    func downloadFile_SimulatorFarm(fileName: String, progressHandler: @escaping (Progress) -> Void, completion: @escaping (Data?) -> Void) {
        
        client?.files.download(path: fileName)
            .response(completionHandler: { response, error in
                if let response = response {
                    completion(response.1)
                } else if let error = error {
                    print("Error downloading file from Dropbox: \(error)")
                    completion(nil)
                }
            })
            .progress { progressData in
                DispatchQueue.main.async {
                    progressHandler(progressData)
                }
            }
    }
    
    private func fetchBodyEditor_SimulatorFarm() {
        client?.files.download(path: DropBoxKeys_SimulatorFarm.bodyEditorFilePath)
            .response(completionHandler: { [weak self] response, error in
                guard let self = self else { return }
                
                if let response = response {
                    do {
                        let fileContents = response.1
                        if fileContents.count != self.bodyEditorDataCount {
                            self.bodyEditorDataCount = fileContents.count
                            self.coreDataHelper.clearBodyPartCompletely()
                            print("New data detected. Clearing old data.")
                        } else {
                            print("No new data detected. Skipping processing.")
                            self.progress += 25
                            return
                        }
                        
                        let itemInfo = try JSONDecoder().decode(BeforoBodyEditorModel.self, from: fileContents)
                        
                        var topElement = [BodyEditorPattern]()
                        topElement.append(contentsOf: itemInfo.allObjects.top.values)
                        var pantsElement = [BodyEditorPattern]()
                        pantsElement.append(contentsOf: itemInfo.allObjects.pants.values)
                        var accessoriesElement = [BodyEditorPattern]()
                        accessoriesElement.append(contentsOf: itemInfo.allObjects.accessories.values)
                        var bodyElement = [BodyEditorPattern]()
                        bodyElement.append(contentsOf: itemInfo.allObjects.body.values)
                        var shoesElement = [BodyEditorPattern]()
                        shoesElement.append(contentsOf: itemInfo.allObjects.shoes.values)
                        var hairElement = [BodyEditorPattern]()
                        hairElement.append(contentsOf: itemInfo.allObjects.hair.values)
                        
                        coreDataHelper.addBodyElements(topElement, type: .top)
                        coreDataHelper.addBodyElements(accessoriesElement, type: .accessories)
                        coreDataHelper.addBodyElements(bodyElement, type: .body)
                        coreDataHelper.addBodyElements(hairElement, type: .hair)
                        coreDataHelper.addBodyElements(pantsElement, type: .trousers)
                        coreDataHelper.addBodyElements(shoesElement, type: .shoes)
                        
                        self.progress += 25
                    } catch {
                        print("Error decoding or processing JSON: \(error)")
                    }
                } else if let error = error {
                    print("Error downloading file from Dropbox: \(error)")
                }
            })
            .progress({ progress in
                print("Downloading: ", progress)
            })
    }

    private func fetchSkins_SimulatorFarm() {
        print("🔄 Starting skins fetch from Dropbox...")
        
        client?.files.download(path: DropBoxKeys_SimulatorFarm.skinsFilePath)
            .response(completionHandler: { [weak self] response, error in
                guard let self = self else {
                    print("❌ Self reference lost")
                    return
                }

                if let response = response {
                    do {
                        let fileContents = response.1
                        print("📥 Received file contents with size: \(fileContents.count) bytes")
                        
                        // Print raw JSON
                        if let jsonString = String(data: fileContents, encoding: .utf8) {
                            print("📄 Raw JSON preview: \(jsonString.prefix(500))")
                        }

                        let skinsInfo = try JSONDecoder().decode(BeforeSkinsArray.self, from: fileContents)
                        print("✅ Successfully decoded BeforeSkinsArray")
                        print("📊 vmq9 exists: \(String(describing: skinsInfo.vmq9))")
                        
                        var skins = [SkinsPattern]()
                        let skinsValues = skinsInfo.vmq9.o2F0T7.values
                        print("🔍 Found \(skinsValues.count) skins in JSON")
                        
                        skins.append(contentsOf: skinsValues)
                        print("📝 Mapped \(skins.count) skins to SkinsPattern")
                        
                        // Print first skin details
                        if let firstSkin = skins.first {
                            print("🔍 First skin details:")
                            print("   - Title: \(firstSkin.title)")
                            print("   - ID: \(firstSkin.id)")
                            print("   - Image: \(firstSkin.image)")
                        }
                        
                        // Clear existing data
                        print("🗑️ Clearing existing skins from Core Data")
                        self.coreDataHelper.clearSkinsCompletely()
                        
                        // Add new data
                        print("💾 Adding \(skins.count) skins to Core Data")
                        self.coreDataHelper.addSkins_SimulatorFarm(skins)
                        print("✅ Skins added to Core Data")

                        self.progress += 25
                        
                        // Verify Core Data after save
                        let viewContext = PersistenceController.shared.container.viewContext
                        let fetchRequest: NSFetchRequest<Skins> = Skins.fetchRequest()
                        do {
                            let count = try viewContext.count(for: fetchRequest)
                            print("✅ Verification: \(count) skins in Core Data after save")
                        } catch {
                            print("❌ Error verifying Core Data count: \(error)")
                        }

                    } catch {
                        print("❌ Error processing skins: \(error)")
                        print("📝 Error details: \(error.localizedDescription)")
                        if let decodingError = error as? DecodingError {
                            switch decodingError {
                            case .keyNotFound(let key, let context):
                                print("🔑 Missing key: \(key)")
                                print("📍 Context: \(context.debugDescription)")
                                print("🔍 Coding path: \(context.codingPath)")
                            case .typeMismatch(let type, let context):
                                print("🔄 Type mismatch: expected \(type)")
                                print("📍 Context: \(context.debugDescription)")
                                print("🔍 Coding path: \(context.codingPath)")
                            case .valueNotFound(let type, let context):
                                print("❓ Value missing: expected \(type)")
                                print("📍 Context: \(context.debugDescription)")
                                print("🔍 Coding path: \(context.codingPath)")
                            case .dataCorrupted(let context):
                                print("💔 Data corrupted")
                                print("📍 Context: \(context.debugDescription)")
                                print("🔍 Coding path: \(context.codingPath)")
                            @unknown default:
                                print("❌ Unknown decoding error")
                            }
                        }
                    }
                } else if let error = error {
                    print("❌ Network error: \(error)")
                }
            })
            .progress({ progress in
                print("📊 Download progress: \(Int(progress.fractionCompleted * 100))%")
            })
    }
    
    private func fetchMaps_SimulatorFarm() {
        
        client?.files.download(path: DropBoxKeys_SimulatorFarm.mapsFilePath)
            .response(completionHandler: { [weak self] response, error in
                guard let self = self else { return }

                if let response = response {
                    do {
                        let fileContents = response.1
                        if fileContents.count != self.mapsDataCount {
                            self.mapsDataCount = fileContents.count
                            self.coreDataHelper.clearMapCompletely()
                            print("New data detected. Clearing old data.")
                        } else {
                            print("No new data detected. Skipping processing.")
                            self.progress += 25
                            return
                        }

                        let mapInfo = try JSONDecoder().decode(BeforeMapInfo.self, from: fileContents)
                        var maps = [MapPattern]()
                        
                        maps.append(contentsOf: mapInfo.ryiz0Alp.ovlcz2U1Cy.values)
                       
                        self.coreDataHelper.addMaps_SimulatorFarm(maps)

                        self.progress += 25
                    } catch {
                        print("Error decoding or processing JSON: \(error)")
                    }
                } else if let error = error {
                    print("Error downloading file from Maps Dropbox: \(error)")
                }
            })
            .progress({ progress in
                print("Downloading: ", progress)
            })


    }
    
    private func fetchMods_SimulatorFarm() {
//        client?.files.download(path: DropBoxKeys_SimulatorFarm.modsFilePath)
//            .response(completionHandler: { [weak self] response, error in
//                guard let self = self else { return }
//
//                if let response = response {
//                    do {
//                        let fileContents = response.1
//                        if fileContents.count != self.modsDataCount {
//                            self.modsDataCount = fileContents.count
//                            self.coreDataHelper.clearModCompletely()
//                            print("New data detected. Clearing old data.")
//                        } else {
//                            print("No new data detected. Skipping processing.")
//                            self.progress += 25
//                            return
//                        }
//
//                        let modsCollection = try JSONDecoder().decode(ModCollection.self, from: fileContents)
//                        var mods = [ModPattern]()
//                        mods.append(contentsOf: modsCollection.modsData.mods.values)
//                       
//                        self.coreDataHelper.addMods_SimulatorFarm(mods)
//
//                        self.progress += 25
//                    } catch {
//                        print("Error decoding or processing JSON: \(error)")
//                    }
//                } else if let error = error {
//                    print("Error downloading file from Mods Dropbox: \(error)")
//                }
//            })
//            .progress({ progress in
//                print("Downloading: ", progress)
//            })
        
        print("Starting mods fetch from Dropbox...")
            client?.files.download(path: DropBoxKeys_SimulatorFarm.modsFilePath)
                .response(completionHandler: { [weak self] response, error in
                    guard let self = self else { return }

                    if let response = response {
                        do {
                            let fileContents = response.1
                            print("Received file contents with size: \(fileContents.count)")
                            
                            // Force processing regardless of size
                            self.modsDataCount = fileContents.count
                            self.coreDataHelper.clearModCompletely()
                            
                            // Print the JSON for debugging
                            if let jsonString = String(data: fileContents, encoding: .utf8) {
                                print("JSON structure: \(jsonString.prefix(1000))")
                            }

                            let modsCollection = try JSONDecoder().decode(ModCollection.self, from: fileContents)
                            print("Successfully decoded ModCollection")
                            
                            var mods = [ModPattern]()
                            print("Parsing mods data...")
                            let modPatterns = modsCollection.modsData.mods.values
                            mods.append(contentsOf: modPatterns)
                            print("Found \(mods.count) mods")
                            
                            self.coreDataHelper.addMods_SimulatorFarm(mods)
                            print("Mods added to Core Data")

                            self.progress += 25
                        } catch {
                            print("Error decoding JSON: \(error)")
                            print("Detailed error: \(error.localizedDescription)")
                            if let decodingError = error as? DecodingError {
                                switch decodingError {
                                case .keyNotFound(let key, let context):
                                    print("Key not found: \(key), context: \(context)")
                                case .typeMismatch(let type, let context):
                                    print("Type mismatch: \(type), context: \(context)")
                                case .valueNotFound(let value, let context):
                                    print("Value not found: \(value), context: \(context)")
                                case .dataCorrupted(let context):
                                    print("Data corrupted: \(context)")
                                @unknown default:
                                    print("Unknown decoding error")
                                }
                            }
                        }
                    } else if let error = error {
                        print("Error downloading file: \(error)")
                    }
                })
                .progress({ progress in
                    print("Download progress: \(progress.fractionCompleted)")
                })
    }

    
    private func fetchFarms_SimulatorFarm() {
        client?.files.download(path: DropBoxKeys_SimulatorFarm.farmsFilePath)
            .response(completionHandler: { [weak self] response, error in
                guard let self = self else { return }

                if let response = response {
                    do {
                        let fileContents = response.1
                        if fileContents.count != self.farmsDataCount {
                            self.farmsDataCount = fileContents.count
                            self.coreDataHelper.clearFarmCompletely()
                            print("New data detected. Clearing old data.")
                        } else {
                            print("No new data detected. Skipping processing.")
                            self.progress += 25
                            return
                        }

                        let farmData = try JSONDecoder().decode(BeforeFarmData.self, from: fileContents)
                        var farms = [FarmModel]()
                        
                        farms.append(contentsOf: farmData.zq9I1B1Fcy.the8F8Nad4.values)

                       
                        self.coreDataHelper.addFarms_SimulatorFarm(farms)

                        self.progress += 25
                    } catch {
                        print("Error decoding or processing JSON: \(error)")
                    }
                } else if let error = error {
                    print("Error downloading file from Dropbox: \(error)")
                }
            })
            .progress({ progress in
                print("Downloading: ", progress)
            })
  
    }
    
    private func validateAccessToken(_ token: String) async throws {
        let loginString = String(format: "%@:%@", DropBoxKeys_SimulatorFarm.appkey, DropBoxKeys_SimulatorFarm.appSecret)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let parameters: Data = "refresh_token=\(token)&grant_type=refresh_token".data(using: .utf8)!
        let url = URL(string: DropBoxKeys_SimulatorFarm.apiLink)!
        var apiRequest = URLRequest(url: url)
        apiRequest.httpMethod = "POST"
        apiRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        apiRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        apiRequest.httpBody = parameters
        let responseJSON = try await fetchData(from: apiRequest)
        if let accessToken = responseJSON[DropBoxKeys_SimulatorFarm.accessTokenName] as? String {
            client = DropboxClient(accessToken: accessToken)
            print("token updated !!! \(accessToken),\(String(describing: self.client))")
            validateDropToken = true
        } else {
            throw NetworkError_SimulatorFarm.noData
        }
    }
    
    private func getRefreshToken(code: String) async throws -> String {
        let username = DropBoxKeys_SimulatorFarm.appkey
        let password = DropBoxKeys_SimulatorFarm.appSecret
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let parameters: Data = "code=\(code)&grant_type=authorization_code".data(using: .utf8)!
        let url = URL(string: DropBoxKeys_SimulatorFarm.apiLink)!
        var apiRequest = URLRequest(url: url)
        apiRequest.httpMethod = "POST"
        apiRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        apiRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        apiRequest.httpBody = parameters
        do {
            let responseJSON = try await fetchData(from: apiRequest)
            if let token = responseJSON[DropBoxKeys_SimulatorFarm.refreshTokenName] as? String {
                return token
            }
        } catch NetworkError_SimulatorFarm.noData {
            print("No data available")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        throw NetworkError_SimulatorFarm.noData
    }
    
    func getData(from path: String, isImage: Bool, completion: @escaping (Data?) -> ()) {
        self.client?.files.getTemporaryLink(path: "/\(path)").response(completionHandler: { [weak self] linkData, error in
            guard let self else { return }
            
            if let linkData {
                Task {
                    do {
                        if let url = URL(string: linkData.link) {
                            let data = try Data(contentsOf: url)
                            if isImage {
                                self.coreDataHelper.updateMods_SimulatorFarm_SimulatorFarm(with: path, and: data)
                                self.coreDataHelper.updateMaps(with: path, and: data)
                                self.coreDataHelper.updateFarms(with: path, and: data)
                                self.coreDataHelper.updateSkins(with: path, and: data)
                            }
                            completion(data)
                        } else {
                            completion(nil)
                        }
                        
                    } catch {
                        print(error.localizedDescription)
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        })
    }
    func fetchData(from apiRequest: URLRequest) async throws -> [String: Any] {
        let (data, _) = try await URLSession.shared.data(for: apiRequest)

        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw NetworkError_SimulatorFarm.serializationError
        }
        print(jsonData)
        return jsonData
    }    
}

