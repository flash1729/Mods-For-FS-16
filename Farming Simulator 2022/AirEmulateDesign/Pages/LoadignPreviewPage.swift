//
//  LoadignPreviewPage.swift
//  Farming Simulator 2022
//
//  Created by Sim on 23/09/24.
//

import SwiftUI

struct LoadignPreviewPage: View {
    @ObservedObject var crotel: LoadingPreviewVMCyan = LoadingPreviewVMCyan()
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @State var workInternetState: Bool = true
    @State var progressTimer: Int = 0
    @State var openMenuPage: Bool = false
    @State var timer: Timer?
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        ZStack {
            if openMenuPage {
                MenuListToApp()
            } else {
                ZStack{
                    Rectangle()
                        .fill(Color.clear)
                        .overlay {
                            Image(bigSize ? IconTurboGear.superBigBackToPad : IconTurboGear.mediumRareBackToPhone)
                                .resizable()
                                .scaledToFill()
                        }
                        .ignoresSafeArea()
                    
                    LoadingLoaderCustomElement(progressTimer: $crotel.progress)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 70)
                    
                    if !workInternetState {
                        LostConnectElement {
                            workInternetState.toggle()
                            openMenuPage.toggle()
                        }
                        .onAppear(){
                            crotel.pauseType = true
                        }
                    }
                }
                .onAppear(){
                    crotel.startLoadingPreviewKitchenToolUsage()
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
                    }
                }
                .onDisappear(){
                    timer?.invalidate()
                }
                .onChange(of: crotel.progress) { newValue in
                    if newValue >= 100 {
                        openMenuPage.toggle()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    LoadignPreviewPage()
        .environmentObject(NetworkManager_SimulatorFarm())
}
