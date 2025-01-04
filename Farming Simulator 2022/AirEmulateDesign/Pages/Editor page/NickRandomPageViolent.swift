//
//  NickRandomPageViolent.swift
//  Farming Simulator 2022
//
//  Created by Sim on 24/09/24.
//  Redesign by Adi
//  no need

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
            
            Color.white
                .ignoresSafeArea()

            VStack(spacing: bigSize ? 31 : 10) {
                NavPanelGreenWithoutFavButton(titleName: "Nickname gen")
                    .padding(.bottom, bigSize ? 10 : 5)
                
                bodySection
                    .frame(maxHeight: .infinity)
                    .paddingFlyBullet()
                
                VStack {
                    GreenButtonWithBorders(
                        title: "Generate new +",
                        action: {
                            withAnimation {
                                let prefix = prefixNicknames.randomElement() ?? ""
                                let suffix = suffixNickName.randomElement() ?? ""
                                generatedNickname = "\(prefix) \(suffix)"
                            }
                        }
                    )
                    .paddingFlyBullet()
                    .padding(.top, bigSize ? 30 : 15)
                    .padding(.bottom, bigSize ? 50 : 25)
                }
                .frame(maxWidth: .infinity)
                .background(
                    ColorTurboGear.colorPicker(.green)
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .edgesIgnoringSafeArea(.bottom)
                )
            }
            .ignoresSafeArea(.all, edges: .top)
            
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
        .onAppear {
            workInternetState = networkManager.checkInternetConnectivity_SimulatorFarm()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private var bodySection: some View {
        VStack {
            if generatedNickname.isEmpty {
                Text("Press the button below to create a new \n nickname")
            } else {
                Text("Your nickname:")
                
                Text(generatedNickname)
                    .font(FontTurboGear.gilroyStyle(size: bigSize ? 30 : 25, type: .bold))
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
        .foregroundColor(ColorTurboGear.colorPicker(.green))
        .font(FontTurboGear.gilroyStyle(size: bigSize ? 28 : 22, type: .semibold))
        .background(
            VStack {
                if copiedText {
                    Text("Copied")
                        .foregroundColor(ColorTurboGear.colorPicker(.green))
                        .font(FontTurboGear.gilroyStyle(size: 16, type: .semibold))
                        .onAppear {
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

struct NickRandomPageViolent_Previews: PreviewProvider {
    static var previews: some View {
        // Creating a preview with required environment objects
        NickRandomPageViolent()
            .environmentObject(NetworkManager_SimulatorFarm()) // Network manager is required
            .environmentObject(DropBoxManager_SimulatorFarm.shared) // DropBox manager if needed
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext) // CoreData context if needed
    }
}
