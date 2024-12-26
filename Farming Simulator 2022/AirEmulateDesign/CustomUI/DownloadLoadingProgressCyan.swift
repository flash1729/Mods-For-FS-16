//
//  DownloadLoadingProgressCyan.swift
//  Farming Simulator 2022
//
//  Created by Sim on 25/09/24.
//

import SwiftUI

struct DownloadLoadingProgressCyan: View {
    @Binding var progressDownload: Double
    @State var howManyDownload: Int = 0
    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        HStack(spacing: bigSize ? 25 : 8){
            ForEach(0..<20) { item in
                RoundedRectangle(cornerRadius: 50)
                    .fill(item < howManyDownload ? ColorTurboGear.colorPicker(.cyan) : ColorTurboGear.colorPicker(.gray))
                    .rotationEffect(.degrees(25))
                    .frame(maxWidth: 15)
            }
        }
        .padding(.vertical, bigSize ? 28 : 32)
        .padding(.horizontal, bigSize ? 35 : 24)
        .frame(height: 90)
        .frame(maxWidth: .infinity)
        .background(ColorTurboGear.colorPicker(.darkGray))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onAppear(){
            howManyDownload = Int(progressDownload * 20)
        }
        .onChange(of: progressDownload) { newValue in
            howManyDownload = Int(progressDownload * 20)
        }
    }
}

#Preview {
    DownloadLoadingProgressCyan(progressDownload: .constant(0.25))
}
