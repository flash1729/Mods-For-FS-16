//
//  NetworkManager.swift
//  Farming Simulator 2022
//
//  Created by Systems
//

import SystemConfiguration
import Foundation
import Network
import SwiftUI

class NetworkManager_SimulatorFarm: ObservableObject {
    @Published private(set) var error = ""
    
    func checkInternetConnectivity_SimulatorFarm() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        if isReachable && !needsConnection {
            if !error.isEmpty {
                error = ""
            }
            return true
        } else {
            if error != "" {
                error = ""
            }
            return false
        }
    }
}
