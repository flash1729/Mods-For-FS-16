//
//  EditorDropdownMenu.swift
//  Farming Simulator 2022
//
//  Created by Aditya Medhane on 06/01/25.
//

import SwiftUI

// Types and enums for the editor dropdown system
enum EditorMenuItem: Identifiable {
    case gender(GenderTypeModel)
    case option(EditorTypePartOfBody)
    
    var id: String {
        switch self {
        case .gender(let type):
            return "gender_\(type.rawValue)"
        case .option(let type):
            return "option_\(type.rawValue)"
        }
    }
    
    var title: String {
        switch self {
        case .gender(let type):
            return type == .man ? "Man" : "Woman"
        case .option(let type):
            return type.stringValue().capitalized
        }
    }
}

struct MenuConfiguration {
    var isExpanded: Bool
    var showGenderSubmenu: Bool
    var selectedOption: EditorTypePartOfBody?
    var currentGender: GenderTypeModel
    
    static let `default` = MenuConfiguration(
        isExpanded: false,
        showGenderSubmenu: false,
        selectedOption: .body,
        currentGender: .man
    )
}




struct EditorDropdownMenu: View {
    @Binding var menuConfig: MenuConfiguration
    let onSelection: (EditorMenuItem) -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        VStack(spacing: 8) {
            // First row is always either Gender or Man/Woman options
            if menuConfig.showGenderSubmenu {
                // Show Man/Woman options
                ForEach([GenderTypeModel.man, .woman], id: \.self) { gender in
                    Button {
                        onSelection(.gender(gender))
                    } label: {
                        menuRow(title: gender == .man ? "Man" : "Woman")
                    }
                }
            } else {
                // Show Gender option
                Button {
                    // Handle expanding gender options
                    menuConfig.showGenderSubmenu = true
                } label: {
                    menuRow(
                        title: "Gender",
                        showChevron: true,
                        rotateChevron: menuConfig.showGenderSubmenu
                    )
                }
            }
            
            // Other menu options stay visible
            ForEach([
                EditorTypePartOfBody.top,
                .accessories,
                .trousers,
                .shoes,
                .hair
            ], id: \.self) { option in
                Button {
                    onSelection(.option(option))
                } label: {
                    menuRow(title: option.stringValue().capitalized)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 44)
        .frame(width: 375)
        .background(
            Color(red: 0.133, green: 0.365, blue: 0.239)
                .opacity(0.95)
        )
        .cornerRadius(16)
    }
    
//    private func handleMenuSelection(_ item: EditorMenuItem) {
//        switch item {
//        case .gender(let type):
//            genderType = type
//            menuConfig.currentGender = type
//            choodedTitle = type == .man ? "Man" : "Woman"
//            menuConfig.showGenderSubmenu = false
//            
//        case .option(let type):
//            if type == .body {
//                menuConfig.showGenderSubmenu = true
//                return
//            }
//            choosedPartModel = type
//            choodedTitle = type.stringValue().capitalized
//        }
//        
//        withAnimation() {
//            menuConfig.isExpanded = false
//        }
//    }
    
    private func menuRow(title: String, showChevron: Bool = false, rotateChevron: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(FontTurboGear.gilroyStyle(
                    size: bigSize ? 20 : 17,
                    type: .medium
                ))
                .foregroundColor(.white)
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(rotateChevron ? 90 : 0))
                    .animation(.easeInOut(duration: 0.2), value: rotateChevron)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorTurboGear.colorPicker(.darkGreen))
        )
    }
}

//struct EditorDropdownMenu: View {
//    @Binding var menuConfig: MenuConfiguration
//    let onSelection: (EditorMenuItem) -> Void
//    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            // Other menu options in reverse order
//            ForEach([
//                EditorTypePartOfBody.hair,
//                .shoes,
//                .trousers,
//                .accessories,
//                .top
//            ], id: \.self) { option in
//                Button {
//                    onSelection(.option(option))
//                } label: {
//                    menuRow(title: option.stringValue().capitalized)
//                }
//            }
//            
//            // Gender menu logic
//            if menuConfig.showGenderSubmenu {
//                // Show Man/Woman options
//                ForEach([GenderTypeModel.woman, .man], id: \.self) { gender in
//                    Button {
//                        onSelection(.gender(gender))
//                    } label: {
//                        menuRow(title: gender == .man ? "Man" : "Woman")
//                    }
//                }
//            } else {
//                // Show Gender option
//                Button {
//                    // Handle expanding gender options
//                    menuConfig.showGenderSubmenu = true
//                } label: {
//                    menuRow(
//                        title: "Gender",
//                        showChevron: true,
//                        rotateChevron: menuConfig.showGenderSubmenu
//                    )
//                }
//            }
//        }
//        .padding(.horizontal, 20)
//        .padding(.top, 44)
//        .padding(.bottom, 20)
//        .frame(width: 375)
//        .background(
//            Color(red: 0.133, green: 0.365, blue: 0.239)
//                .opacity(0.95)
//        )
//        .cornerRadius(16)
//    }
//    
//    private func menuRow(title: String, showChevron: Bool = false, rotateChevron: Bool = false) -> some View {
//        HStack {
//            Text(title)
//                .font(FontTurboGear.gilroyStyle(
//                    size: bigSize ? 20 : 17,
//                    type: .medium
//                ))
//                .foregroundColor(.white)
//            
//            Spacer()
//            
//            if showChevron {
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.white)
//                    .rotationEffect(.degrees(rotateChevron ? 90 : 0))
//                    .animation(.easeInOut(duration: 0.2), value: rotateChevron)
//            }
//        }
//        .padding(.horizontal, 16)
//        .frame(height: 44)
//        .background(
//            RoundedRectangle(cornerRadius: 8)
//                .fill(ColorTurboGear.colorPicker(.darkGreen))
//        )
//    }
//}

struct EditorDropdownMenu_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Regular menu state - iPhone
            EditorDropdownMenu(
                menuConfig: .constant(MenuConfiguration(
                    isExpanded: true,
                    showGenderSubmenu: false,
                    selectedOption: .body,
                    currentGender: .man
                )),
                onSelection: { _ in }
            )
            .previewDisplayName("Regular Menu - iPhone")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.3))
            
            // Gender submenu state - iPhone
            EditorDropdownMenu(
                menuConfig: .constant(MenuConfiguration(
                    isExpanded: true,
                    showGenderSubmenu: true,
                    selectedOption: .body,
                    currentGender: .man
                )),
                onSelection: { _ in }
            )
            .previewDisplayName("Gender Submenu - iPhone")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.3))
        }
    }
}
