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
    
    //drop settings
    static let oldappkey = "kp0lre46ylg5l9s"
    static let oldappSecret = "ka1s56uwhnqy0j4"
    static let oldrefresh_token = "V5M7YQUXEHkAAAAAAAAAAfuoc_FUyHQFfngZvo8oi5yn1cO59ldgwJ4ZGeRhoZRA"
    
    //New drop settings
    static let appkey = "hvfm6nqohkw6vgb"
    static let appSecret = "8pdous5y9mdqyed"
    static let refresh_token = "nupcnxBm3a8AAAAAAAAAAcTBgEylYTVGKveyNqU_6L9cUOQtmc3eIPYu79UYfzCX"
    
    //path to json file
    static let modsFilePath = "/content/6765534fa8c5a/content.json"//new
    static let mapsFilePath = "/content/67655354dd024/content.json" //new
    static let farmsFilePath = "/content/67655355b739c/content.json" //new
    static let skinsFilePath = "/content/67655850cdeb9/content.json"
    static let nicknameFilePath = "/content/????????/content.json"
    static let bodyEditorFilePath = "/content/6765534fb64c5/content.json"
    
    //path to download image from folder
    static let modsImagePartPath = "content/6765534fa8c5a/"//new
    static let mapsImagePartPath = "content/67655354dd024/" //new
    static let farmsImagePartPath = "content/67655355b739c/" //new
    static let skinsImagePartPath = "content/67655850cdeb9/"
    static let bodyEditorImagePartPath = "content/6765534fb64c5/"
    
    //path to download file from folder
    static let modsFilePartPath = "/content/6765534fa8c5a/" //new
    static let mapsFilePartPath = "/content/67655354dd024/" //new
    static let farmsFilePartPath = "/content/67655355b739c/" //new
    static let skinFilePartPath = "/content/67655850cdeb9/"
    
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
