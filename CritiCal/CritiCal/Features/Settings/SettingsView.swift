//
//  SwiftUIView.swift
//  Setting
//
//  Created by Scott Matthewman on 23/09/2025.
//

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
                    NavigationLink {
                        GenresListView()
                    } label: {
                        Label("Genres", systemImage: "list.bullet")
                    }
                    NavigationLink {
                        Text("Publications View")
                    } label: {
                        Label("Publications", systemImage: "newspaper")
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(role: .close, action: close)
                }
            }
        }
    }

    private func close() { dismiss() }
}

#Preview(traits: .sampleData) {
    SettingsView()
}
