//
//  BottomFilterBarView.swift
//  Farming Simulator 2022
//
//  Created by Aditya Medhane on 27/12/24.
//

import SwiftUI

struct BottomFilterBarView: View {
    @Binding var selectedFilter: FilterType_SimulatorFarm
    var onFilterChange: (FilterType_SimulatorFarm) -> Void
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        // Container for the entire bottom bar
        VStack(spacing: 0) {
            // Green background container with buttons
            HStack(spacing: 8) {
                // Individual filter buttons
                filterButton(type: .all, title: "All")
                filterButton(type: .new, title: "New")
                filterButton(type: .favorite, title: "Favorite")
                filterButton(type: .top, title: "Top")
            }
            .padding(.horizontal, bigSize ? 24 : 16)
            .padding(.vertical, bigSize ? 20 : 12)
            .background(ColorTurboGear.colorPicker(.darkGreen))
            .cornerRadius(bigSize ? 24 : 16)
            .padding(.horizontal, bigSize ? 40 : 20)
            
            // Safe area spacing for home indicator
            Rectangle()
                .fill(Color.clear)
                .frame(height: bigSize ? 40 : 20)
        }
        .background(Color.black)
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    private func filterButton(type: FilterType_SimulatorFarm, title: String) -> some View {
        Button(action: {
            selectedFilter = type
            onFilterChange(type)
        }) {
            Text(title)
                .font(FontTurboGear.montserratStyle(
                    size: bigSize ? 20 : 16,
                    type: .semibold
                ))
                // Text color changes based on selection
                .foregroundColor(selectedFilter == type ? .black : .white)
                .frame(maxWidth: .infinity)
                .frame(height: bigSize ? 48 : 36)
                // Button background changes based on selection
                .background(
                    selectedFilter == type ? Color.white : Color.clear
                )
                .cornerRadius(bigSize ? 16 : 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Preview provider for testing
struct BottomFilterBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // iPhone preview
            BottomFilterBarView(
                selectedFilter: .constant(.all),
                onFilterChange: { _ in }
            )
            .previewDisplayName("iPhone")
            
            // iPad preview
            BottomFilterBarView(
                selectedFilter: .constant(.all),
                onFilterChange: { _ in }
            )
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
            .previewDisplayName("iPad")
        }
    }
}
