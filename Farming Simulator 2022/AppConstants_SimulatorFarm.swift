//
//  AppConstants_SimulatorFarm.swift
//  Tamagochi
//
//  Created by Systems
//

import Foundation
import CoreText
import SwiftUI

struct DropBoxKeys_SimulatorFarm {
    static let token = "czHFetFkAxAAAAAAAAAEYi9LbxJIX7NRHst4nQgZL8A"
    static let apiLink = "https://api.dropboxapi.com/oauth2/token"
    
    //New drop settings
    static let appkey = "kp0lre46ylg5l9s"
    static let appSecret = "ka1s56uwhnqy0j4"
    static let refresh_token = "V5M7YQUXEHkAAAAAAAAAAfuoc_FUyHQFfngZvo8oi5yn1cO59ldgwJ4ZGeRhoZRA"
    
    //path to json file
    static let modsFilePath = "/content/66d83705a064e/content.json"
    static let mapsFilePath = "/content/66d83705ad3fa/content.json"
    static let farmsFilePath = "/content/66d83705b42fe/content.json"
    static let skinsFilePath = "/content/66d83705b0fa0/content.json"
    static let nicknameFilePath = "/content/????????/content.json"
    static let bodyEditorFilePath = "/content/6710c045dae81/content.json"
    
    //path to download image from folder
    static let modsImagePartPath = "content/66d83705a064e/"
    static let mapsImagePartPath = "content/66d83705ad3fa/"
    static let farmsImagePartPath = "content/66d83705b42fe/"
    static let skinsImagePartPath = "content/66d83705b0fa0/"
    static let bodyEditorImagePartPath = "content/6710c045dae81/"
    
    //path to download file from folder
    static let modsFilePartPath = "/content/66d83705a064e/"
    static let mapsFilePartPath = "/content/66d83705ad3fa/"
    static let farmsFilePartPath = ""
    static let skinFilePartPath = "/content/66d83705b0fa0/"
    
    //
    static let refreshTokenName = "refresh_token"
    static let accessTokenName = "access_token"
    
    // TO GET TOKEN
    // "https://www.dropbox.com/oauth2/authorize?client_id=uo6lh6pwb54xv2t&response_type=code&token_access_type=offline"
}

enum NetworkError_SimulatorFarm: Error {
    case noData
    case serializationError
    case invalidResponse
}
