//
//  EditorDropdownButton.swift
//  Farming Simulator 2022
//
//  Created by Aditya Medhane on 14/01/25.
//
import SwiftUI

struct EditorDropdownButton: View {
    // MARK: - Properties
    @Binding var isExpanded: Bool
    @Binding var selectedTitle: String
    @Binding var selectedPart: EditorTypePartOfBody?
    @Binding var currentGender: GenderTypeModel
    @State private var showingGenderOptions: Bool = false
    
    let onGenderChange: (GenderTypeModel) -> Void // Add this callback
    let onTap: () -> Void
    
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    // Constants
    private let buttonHeight: CGFloat = 44
    private let menuSpacing: CGFloat = 8
    private let cornerRadius: CGFloat = 8
    
    // Categories to display
    private let categories = [
        "Gender",
        "Top",
        "Accessories",
        "Bottom",
        "Shoes",
        "Hair"
    ]
    
//     MARK: - Body
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                if isExpanded {
                    if showingGenderOptions {
                        // Gender selection menu
                        VStack(spacing: menuSpacing) {
                            ForEach([GenderTypeModel.man, .woman], id: \.self) { gender in
                                Button(action: { handleSelection(gender: gender) }) {
                                    Text(gender == .man ? "Man" : "Woman")
                                        .font(FontTurboGear.gilroyStyle(
                                            size: bigSize ? 22 : 16,
                                            type: .semibold
                                        ))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 16)
                                        .frame(height: buttonHeight)
                                        .background(ColorTurboGear.colorPicker(.darkGreen))
                                        .cornerRadius(cornerRadius)
                                }
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal)
                        .background(ColorTurboGear.colorPicker(.green))
                    } else {
                        // Main categories menu
                        VStack(spacing: menuSpacing) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    handleCategorySelection(category)
                                }) {
                                    HStack {
                                        Text(category)
                                            .font(FontTurboGear.gilroyStyle(
                                                size: bigSize ? 22 : 16,
                                                type: .semibold
                                            ))
                                        Spacer()
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical)
                                    .frame(height: buttonHeight)
                                    .background(ColorTurboGear.colorPicker(.darkGreen))
                                    .cornerRadius(cornerRadius)
                                }
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal)
                        .background(ColorTurboGear.colorPicker(.green))
                    }
                }
                
                // Main button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if isExpanded && showingGenderOptions {
                            // If showing gender options, close them and return to main menu
                            showingGenderOptions = false
                        } else {
                            // Otherwise toggle the menu
                            onTap()
                            isExpanded.toggle()
                        }
                    }
                }) {
                    HStack {
                        Text(selectedTitle)
                            .font(FontTurboGear.gilroyStyle(
                                size: bigSize ? 22 : 16,
                                type: .semibold
                            ))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: "chevron.up")
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(isExpanded ? -180 : 0))
                    }
                    .padding(.horizontal, 16)
                    .frame(height: buttonHeight)
                    .background(ColorTurboGear.colorPicker(.darkGreen))
                    .cornerRadius(cornerRadius)
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity) // Make VStack take full width
            .background(ColorTurboGear.colorPicker(.green))
        }
        .frame(maxWidth: .infinity) // Make outer VStack take full width
        .frame(height: buttonHeight, alignment: .bottom)
        .ignoresSafeArea(.all, edges: [.leading, .trailing]) // Ignore safe area on sides
        .zIndex(100)
    }

    
    private func handleCategorySelection(_ category: String) {
        switch category {
        case "Gender":
            selectedPart = .body
            withAnimation {
                showingGenderOptions = true  // Show gender options instead of closing
            }
            return  // Return early to prevent closing the menu
        case "Top":
            selectedPart = .top
            selectedTitle = category
        case "Accessories":
            selectedPart = .accessories
            selectedTitle = category
        case "Bottom":
            selectedPart = .trousers
            selectedTitle = category
        case "Shoes":
            selectedPart = .shoes
            selectedTitle = category
        case "Hair":
            selectedPart = .hair
            selectedTitle = category
        default:
            break
        }
        isExpanded = false
        showingGenderOptions = false  // Reset gender options
    }
    
    private func handleSelection(gender: GenderTypeModel? = nil, part: EditorTypePartOfBody? = nil) {
            withAnimation {
                if let gender = gender {
                    currentGender = gender
                    selectedTitle = gender == .man ? "Man" : "Woman"
                    selectedPart = .body  // Reset to body part
                    onGenderChange(gender) // Call the callback to handle state reset
                }
                
                isExpanded = false
                showingGenderOptions = false
        }
    }
}


