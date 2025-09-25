//
//  LargeGenreCircle.swift
//  CritiCal
//
//  Created by Scott Matthewman on 25/09/2025.
//

import SwiftUI

struct LargeGenreCircle: View {
    var symbolName: String
    var color: Color

    var body: some View {
        Circle()
            .fill(.tint.quaternary)
            .shadow(radius: 8)
            .overlay {
                Image(systemName: symbolName)
                    .resizable()
                    .foregroundStyle(.tint)
                    .scaledToFit()
                    .padding(15)
                    .shadow(color: .white, radius: 2)
            }
            .frame(height: 100)
            .tint(color.gradient)
    }
}

#Preview {
    LargeGenreCircle(symbolName: "theatermasks", color: .green)
}
