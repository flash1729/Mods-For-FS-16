//
//  NavButtonMiniIcon.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct NavButtonMiniIcon: View {
    let typeOfImage: IconTurboGear.TopNavIconTurbo
    
    var body: some View {
        Image(typeOfImage.sendNameOfIcon())
            .resizable()
            .frame(width: 44, height: 44)
    }
}

//struct NavButtonMiniIcon: View {
//    @State var typeOfImage: IconTurboGear.TopNavIconTurbo
//    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
//    
//    // Dynamic sizing properties based on device type
//    private var buttonSize: CGFloat {
//        bigSize ? 80 : 44  // 80px for iPad, 44px for iPhone
//    }
//    
//    // Calculate image size to maintain proper padding ratio
//    private var imageSize: CGFloat {
//        bigSize ? 48 : 24  // Allows for 16px padding on iPad, 10px on iPhone
//    }
//    
//    var body: some View {
//        Button(action: {
//            // Add your button action here
//        }) {
//            Image(typeOfImage.sendNameOfIcon())
//                .resizable()
//                .scaledToFit()
//                .frame(width: imageSize, height: imageSize) // Inner frame for image
//                .frame(width: buttonSize, height: buttonSize) // Outer frame for touch target
//                .foregroundColor(.primary)
//        }
//        .buttonStyle(PlainButtonStyle())
//        .scaleEffect(1.0)
//        .animation(.easeInOut, value: 1.0)
//    }
//}

#Preview {
    NavButtonMiniIcon(typeOfImage: .backChev)
}
