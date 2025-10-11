//
//  SwiftUIView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 09/10/2025.
//

import SwiftUI

public struct CircularIcon: View {
    private var systemImage: String
    private var diameter: CGFloat

    public init(
        systemImage: String,
        diameter: CGFloat = 44
    ) {
        self.systemImage = systemImage
        self.diameter = diameter
    }

    public var body: some View {
        Image(systemName: systemImage)
            .resizable()
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
