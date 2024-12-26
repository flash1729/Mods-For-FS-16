//
//  NickRandomPageViolent.swift
//  Farming Simulator 2022
//
//  Created by Sim on 24/09/24.
//

import SwiftUI

struct NickRandomPageViolent: View {
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @AppStorage("generatedNickname") var generatedNickname: String = ""
    @State var copiedText: Bool = false
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @State var workInternetState: Bool = true
    @State var timer: Timer?
    let prefixNicknames: [String] = [
        "Skyward",
        "Cloud-borne",
        "Winged",
        "Soaring",
        "Aeriel",
        "Heavenly",
        "Bird-like",
        "Glider",
        "Serene",
        "Falcon"
    ]
    
    let suffixNickName: [String] = [
        "Aviator",
        "Sky-captain",
        "Wingman",
        "Copilot",
        "Grower",
        "Flight-engineer",
        "Navigator",
        "Air-traffic controller",
        "Ground-crew",
        "Passenger"
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: bigSize ? 31 : 10) {
                NavPanelCyanWithoutFavButton(titleName: "Nickname")
                .padding(.bottom, bigSize ? 10 : 5)
                
                bodySection
                    .frame(maxHeight: .infinity)
                    .paddingFlyBullet()
                
                BlueButtonWithBorders(blueButtonTap: {
                    let prefix = prefixNicknames.randomElement()
                    let suffix = suffixNickName.randomElement()
                    withAnimation {
                        generatedNickname = "\(prefix ?? "") \(suffix ?? "")"
                    }
                }, titleButton: "Generate name", infinityWidth: true)
                .paddingFlyBullet()
                .padding(.bottom, bigSize ? 50 : 10)
            }
            .ignoresSafeArea(.all, edges: .top)
            .frame(maxHeight: .infinity, alignment: .top)
            
            if !workInternetState {
                LostConnectElement {
                    workInternetState.toggle()
                    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                        if workInternetState {
                            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
                        }
                    }
                }
            }
        }
        .onAppear(){
            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
        }
    }
    
    private var bodySection: some View {
        VStack {
            if generatedNickname.isEmpty {
                Text("Generate your new nickname")
            } else {
                Text("Your nickname:")
                
                Text("\(generatedNickname)")
                    .font(FontTurboGear.montserratStyle(size: bigSize ? 30 : 25, type: .bold))
                    .transition(.opacity)
                    .multilineTextAlignment(.center)
                    .onTapGesture {
                        if !generatedNickname.isEmpty {
                            UIPasteboard.general.string = generatedNickname
                            copiedText = true
                        }
                    }
                
                
            }
        }
        .foregroundColor(.white)
        .font(FontTurboGear.montserratStyle(size: bigSize ? 28 : 22, type: .semibold))
        .background(
            VStack {
                if copiedText {
                    Text("Copied")
                        .foregroundColor(.white)
                        .font(FontTurboGear.montserratStyle(size: 16, type: .semibold))
                        .onAppear(){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                copiedText = false
                            }
                        }
                        .offset(y: bigSize ? 70 : 50)
                }
            }
        )
    }
}

#Preview {
    NickRandomPageViolent()
}

