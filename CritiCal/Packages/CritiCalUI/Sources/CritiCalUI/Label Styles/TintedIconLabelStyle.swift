//
//  TintedIconLabelStyle.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 22/09/2025.
//

import SwiftUI

public struct TintedIconLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .foregroundStyle(.tint)
        }
    }
}

public extension LabelStyle where Self == TintedIconLabelStyle {
    static var tintedIcon: TintedIconLabelStyle { .init() }
}

#Preview {
    VStack(alignment: .leading) {
        Text("Standard")
            .font(.headline)
        Label("Hello, World!", systemImage: "globe")
        Divider()
        Text("Tinted Icon")
            .font(.headline)
        Label("Hello, World!", systemImage: "globe")
            .labelStyle(.tintedIcon)
    }
    .padding()
}
