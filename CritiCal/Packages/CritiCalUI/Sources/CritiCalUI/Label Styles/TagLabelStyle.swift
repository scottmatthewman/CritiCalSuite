//
//  TagLabelStyle.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 22/09/2025.
//

import SwiftUI

public struct TagLabelStyle: LabelStyle {
    @ScaledMetric(relativeTo: .caption2) private var horizontalPadding: CGFloat = 8
    @ScaledMetric(relativeTo: .caption2) private var verticalPadding: CGFloat = 4

    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            configuration.icon
            configuration.title
        }
        .font(.caption2.bold())
        .foregroundStyle(.tint)
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
        .background(.tint.quaternary, in: .capsule)
    }
}

public extension LabelStyle where Self == TagLabelStyle {
    static var tag: TagLabelStyle { .init() }
}

#Preview {
    HStack {
        VStack(alignment: .leading) {
            Label("Theatre", systemImage: "theatermasks")
                .labelStyle(.tag)
            Label("Magic, Fantasy & Roleplay", systemImage: "wand.and.stars")
                .labelStyle(.tag)
                .tint(.orange)
            Label("Music", systemImage: "music.note")
                .labelStyle(.tag)
                .tint(.purple)
        }
    }
}

