//
//  IcomTurboGear.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import Foundation

enum IconTurboGear {
    static let NoInternetIconForceNitro = "NoInternetIconForceNitro"
    static let LoaderMaskForImage = "LoaderMaskForImage"
    static let mediumRareBackToPhone = "mediumRareBackToPhone"
    static let superBigBackToPad = "superBigBackToPad"
    static let generateNewAvatar = "generateNewAvatar"
    
    enum MenuIconTurbo {
        case dads
        case maps
        case plane
        case angar
        case nickGen
        case avaGen
        case editor
        
        static let shirtForEditor = "shirtForEditor"
        static let gearKeyForDads = "gearKeyForDads"
        static let mapForMaps = "mapForMaps"
        static let planeForPlane = "planeForPlane"
        static let angarForFarms = "angarForFarms"
        static let diceForNickname = "diceForNickname"
        static let peopleForImageGenegator = "peopleForImageGenegator"
        
        func sendNameOfIcon() -> String {
            switch self {
            case .dads:
                return IconTurboGear.MenuIconTurbo.gearKeyForDads
            case .maps:
                return IconTurboGear.MenuIconTurbo.mapForMaps
            case .plane:
                return IconTurboGear.MenuIconTurbo.planeForPlane
            case .angar:
                return IconTurboGear.MenuIconTurbo.angarForFarms
            case .nickGen:
                return IconTurboGear.MenuIconTurbo.diceForNickname
            case .avaGen:
                return IconTurboGear.MenuIconTurbo.peopleForImageGenegator
            case .editor:
                return IconTurboGear.MenuIconTurbo.shirtForEditor
            }
        }
        
        func sendTitleOfItem() -> String {
            switch self {
            case .dads:
                return "Mods"
            case .maps:
                return "Maps"
            case .plane:
                return "Wallpaper"
            case .angar:
                return "Skins"
            case .nickGen:
                return "Nick generation"
            case .avaGen:
                return "Avatar generation"
            case .editor:
                return "Editor"
            }
        }
    }
    
    enum TopNavIconTurbo {
        static let topNavWindowIcon = "topNavWindowIcon"
        static let topNamBackChevron = "topNamBackChevron"
        static let topNavFavoriteInactiveIcon = "topNavFavoriteInactiveIcon"
        static let topNavFavoriteActiveIcon = "topNavFavoriteActiveIcon"
        static let chevronLeftButtonCustom = "chevronLeftButtonCustom"
        static let crateNewManualAvatar = "crateNewManualAvatar"
        static let saveNewManualAvavtar = "saveNewManualAvavtar"
        static let createAvatarGeneratorRandom = "createAvatarGeneratorRandom"
        static let removeItemFromDB = "removeItemFromDB"
        static let editItemFromDB = "editItemFromDB"
        static let saveImageToGallary = "saveImageToGallary"
        
        case windowIcon
        case backChev
        case favActive
        case favInactive
        case chevronLeft
        case createNewAvatar
        case saveNewAvavtar
        case createAvatarRandom
        case removeItem
        case editItem
        case saveImage
        
        func sendNameOfIcon() -> String {
            switch self {
            case .windowIcon:
                return IconTurboGear.TopNavIconTurbo.topNavWindowIcon
            case .backChev:
                return IconTurboGear.TopNavIconTurbo.topNamBackChevron
            case .favActive:
                return IconTurboGear.TopNavIconTurbo.topNavFavoriteActiveIcon
            case .favInactive:
                return IconTurboGear.TopNavIconTurbo.topNavFavoriteInactiveIcon
            case .chevronLeft:
                return IconTurboGear.TopNavIconTurbo.chevronLeftButtonCustom
            case .createNewAvatar:
                return IconTurboGear.TopNavIconTurbo.crateNewManualAvatar
            case .saveNewAvavtar:
                return IconTurboGear.TopNavIconTurbo.saveNewManualAvavtar
            case .createAvatarRandom:
                return IconTurboGear.TopNavIconTurbo.createAvatarGeneratorRandom
            case .removeItem:
                return IconTurboGear.TopNavIconTurbo.removeItemFromDB
            case .editItem:
                return IconTurboGear.TopNavIconTurbo.editItemFromDB
            case .saveImage:
                return IconTurboGear.TopNavIconTurbo.saveImageToGallary
            }
        }
    }
    
    enum FilterIconTurbo: String {
        case filterAllItems
        case filterNewItems
        case filterFavoriteItems
        case filterTopItems
        
        func sendTitleOfIcon() -> String {
            switch self {
            case .filterAllItems:
                return "All"
            case .filterNewItems:
                return "New"
            case .filterFavoriteItems:
                return "Favorite"
            case .filterTopItems:
                return "Top"
            }
        }
    }
    
    enum SaveStateIconTurbo: String {
        case saveSuccesfulIconElement
        case saveFailedIconElement
        func sendTitleOfIcon() -> String {
            switch self {
            case .saveSuccesfulIconElement:
                return "Save successful"
            case .saveFailedIconElement:
                return "Failed"
            }
        }
    }
    
    enum FavoritHeartIconTurbo {
        static let unfavoriteHeartCyan = "UnfavoriteHeartCyan"
        static let favoriteHeartCyan = "FavoriteHeartCyan"
    }
}
