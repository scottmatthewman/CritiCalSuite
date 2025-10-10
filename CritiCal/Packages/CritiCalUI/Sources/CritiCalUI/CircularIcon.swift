//
//  SwiftUIView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 09/10/2025.
//

import SwiftUI

public struct CircularIcon: View {
    private var systemImage: String
    private var diameter: CGFloat = 44

    public init(systemImage: String) {
        self.systemImage = systemImage
    }

    public var body: some View {
        Image(systemName: systemImage)
            .resizable()
            .symbolVariant(.fill)
            .scaledToFit()
            .padding(diameter / 5)
            .frame(width: diameter, height: diameter)
            .foregroundStyle(.tint)
            .background(.tint.quaternary, in: .circle)
    }
}

#Preview {
    CircularIcon(systemImage: "theatermasks")
}
