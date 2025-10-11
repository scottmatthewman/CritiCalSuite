//
//  SwiftUIView.swift
//  Setting
//
//  Created by Scott Matthewman on 23/09/2025.
//

import CritiCalExtensions
import CritiCalUI
import CritiCalStore
import SwiftUI

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    public init() { }

    public var body: some View {
        NavigationStack {
            List {
                Section("Metadata settings") {
                    NavigationLink("Genres", systemImage: "list.bullet", destination: GenresListView.init)
                    NavigationLink("Publications", systemImage: "newspaper", destination: PublicationsListView.init)
                }
            }
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar(content: toolbarContent)
        }
    }

    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction, content: closeButton)
    }

    @ViewBuilder
    private func closeButton() -> some View {
        Button(role: .close, action: close)
    }

    private func close() { dismiss() }
}

#Preview(traits: .sampleData) {
    SettingsView()
}
