//
//  MenuListToApp.swift
//  Farming Simulator 2022
//
//  Created by Sim on 24/09/24.
//

import SwiftUI

struct MenuListToApp: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dropBoxManager: DropBoxManager_SimulatorFarm
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BodyElement.idElement, ascending: false)])
        private var allData: FetchedResults<BodyElement>
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    @ObservedObject var crotel: LoadingPreviewVMCyan = LoadingPreviewVMCyan()
    @State var itemTypeChoosed: IconTurboGear.MenuIconTurbo?
    @State var openPage: Bool = false
    
    @State var workInternetState: Bool = true
    @EnvironmentObject private var networkManager: NetworkManager_SimulatorFarm
    @State var timer: Timer?
    @State var showDownloadView: Bool = false
    @ObservedObject var viewMotel: EditorViewModel = EditorViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // New white background
                Color.white.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    // Menu Title
                    Text("Menu")
                        .font(FontTurboGear.gilroyStyle(size: bigSize ? 44 : 34, type: .bold))
                        .foregroundColor(ColorTurboGear.colorPicker(.darkGreen))
                        .padding(.horizontal, 20)
                        .padding(.top, bigSize ? 80 : 60)
                        .padding(.bottom, bigSize ? 40 : 24)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        listOfButtons
                            .padding(.horizontal, 20)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                allLinks
                
                // Loading View
                if showDownloadView {
                    LoadingLoaderCustomElement(progressTimer: $crotel.progress)
                        .frame(maxHeight: .infinity, alignment: .center)
                        .onAppear {
                            crotel.progress = 0
                            Task {
                                await crotel.addAllElementToCoreData(allData: allData, dropBoxManager: dropBoxManager, viewContext: viewContext)
                            }
                        }
                        .onChange(of: crotel.progress) { newValue in
                            if newValue >= 100 {
                                DispatchQueue.main.async {
                                    openPage.toggle()
                                    withAnimation {
                                        showDownloadView.toggle()
                                    }
                                    timer?.invalidate()
                                }
                            }
                        }
                }
                
                // No Internet View
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
    }
    
    private var listOfButtons: some View {
        VStack(spacing: bigSize ? 16 : 12) {
            ForEach(IconTurboGear.MenuIconTurbo.allCases, id: \.self) { menuType in
                MenuButton(
                    iconType: menuType,
                    isSelected: menuType == itemTypeChoosed,
                    action: {
                        itemTypeChoosed = menuType
                        if menuType == .avaGen || menuType == .editor {
                            showDownloadView.toggle()
                        } else {
                            openPage.toggle()
                        }
                    }
                )
            }
        }
    }
    
    private var allLinks: some View {
        VStack {
            NavigationLink(isActive: $openPage, destination: {
                switch itemTypeChoosed {
                case .dads:
                    MotorsPageViolent()
                        .navigationBarBackButtonHidden()
                case .maps:
                    MapsPageViolent()
                        .navigationBarBackButtonHidden()
                case .plane:
                    WallpapersPageViolent()
                        .navigationBarBackButtonHidden()
                case .angar:
                    AngarsPageViolent()
                        .navigationBarBackButtonHidden()
                case .nickGen:
                    NickRandomPageViolent()
                        .navigationBarBackButtonHidden()
                case .avaGen:
                    AvatarRandomPageViolent(viewMotel: viewMotel)
                        .navigationBarBackButtonHidden()
                case .editor:
                    CreateSelfAvatarAndEditPageViolent(viewMotel: viewMotel)
                        .navigationBarBackButtonHidden()
                case nil:
                    MotorsPageViolent()
                        .navigationBarBackButtonHidden()
                }
            }, label: { EmptyView() })
        }
    }
}

// New Menu Button Component
struct MenuButton: View {
   let iconType: IconTurboGear.MenuIconTurbo //no need
   let isSelected: Bool
   let action: () -> Void
   
   var body: some View {
       Button(action: action) {
           Text(iconType.sendTitleOfItem())
               .font(FontTurboGear.gilroyStyle(size: 18, type: .bold))
               .foregroundColor(isSelected ? .white : ColorTurboGear.colorPicker(.darkGreen))
               .frame(maxWidth: .infinity)
               .padding(.vertical, 12)
               .padding(.horizontal, 24)
               .background(
                   RoundedRectangle(cornerRadius: 8)
                       .fill(isSelected ? ColorTurboGear.colorPicker(.darkGreen) : .white)
                       .overlay(
                           RoundedRectangle(cornerRadius: 8)
                               .stroke(Color(.sRGB, red: 143/255, green: 143/255, blue: 143/255, opacity: 0.25), lineWidth: 1)
                       )
                       .shadow(color: Color(.sRGB, red: 143/255, green: 143/255, blue: 143/255, opacity: 0.25), radius: 8, x: 0, y: 4)
               )
               .frame(height: 47)
       }
   }
}

// New preview upgraded to avoid xcode crashes
#if DEBUG
struct MenuListToApp_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext
        
        // Create a sample BodyElement for preview
        let bodyElement = BodyElement(context: context)
        bodyElement.idElement = UUID()
        bodyElement.previewImageString = "sample"
        bodyElement.editImageString = "sample"
        bodyElement.genderType = 0
        bodyElement.typeOfPart = 0
        bodyElement.zIndex = "0"
        
        try? context.save()
        
        return Group {
            // iPhone Preview
            MenuListToApp(
                crotel: LoadingPreviewVMCyan(),
                viewMotel: EditorViewModel()
            )
            .environment(\.managedObjectContext, context)
            .environmentObject(NetworkManager_SimulatorFarm())
            .environmentObject(DropBoxManager_SimulatorFarm.shared)
            .previewDisplayName("iPhone")
            
            // iPad Preview
            MenuListToApp(
                crotel: LoadingPreviewVMCyan(),
                viewMotel: EditorViewModel()
            )
            .environment(\.managedObjectContext, context)
            .environmentObject(NetworkManager_SimulatorFarm())
            .environmentObject(DropBoxManager_SimulatorFarm.shared)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewDisplayName("iPad")
        }
    }
}
#endif

//#Preview {
//    MenuListToApp()
//}
