//
//  mods_farming_simulator22App.swift
//  Farming Simulator 2022
//
//  Created by Systems
//

import SwiftUI
import AVFoundation

@main
struct FlightSimulatorApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let dropBox = DropBoxManager_SimulatorFarm.shared
    @StateObject private var networkManager = NetworkManager_SimulatorFarm()
    
    init() {
        dropBox.initialize_FarmSimulator()
        UIButton.appearance().isMultipleTouchEnabled = false
        UIButton.appearance().isExclusiveTouch = true
        UIView.appearance().isMultipleTouchEnabled = false
        UIView.appearance().isExclusiveTouch = true
        UITabBar.appearance().isExclusiveTouch = true
        UITabBar.appearance().isMultipleTouchEnabled = false
    }
    
    var body: some Scene {
        WindowGroup {
            VStack {
                LoadignPreviewPage()
                    .environmentObject(networkManager)
                    .environmentObject(dropBox)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            .preferredColorScheme(.dark)
            .task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}
