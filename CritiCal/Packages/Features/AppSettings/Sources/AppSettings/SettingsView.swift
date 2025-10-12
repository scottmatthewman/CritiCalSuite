//
//  SwiftUIView.swift
//  Setting
//
//  Created by Scott Matthewman on 23/09/2025.
//

import CritiCalSettings
import SwiftUI

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Setting(.calculateTravelTime) private var calculateTravelTime
    @Setting(.preferredTransitMode) private var preferredTransitMode
    @Setting(.directionsProvider) private var directionsProvider

    public init() { }

    public var body: some View {
        NavigationStack {
            List {
                Section("Metadata settings") {
                    NavigationLink("Genres", systemImage: "list.bullet", destination: GenresListView.init)
                    NavigationLink("Publications", systemImage: "newspaper", destination: PublicationsListView.init)
                }

                Section {
                    Toggle(isOn: $calculateTravelTime) {
                        Text("Show travel time estimates")
                        Text("Always provided by Apple Maps")
                    }
                    TransitModePicker(transitMode: $preferredTransitMode)
                    DirectionsProviderPicker(selection: $directionsProvider)
                } header: {
                    Text("Maps and Directions")
                } footer: {
                    Text("Your chosen transit mode will be used for travel time estimates, and will be passed to third party directions providers where possible.\n\nDirections open in selected app, or on their website if not available")
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

#Preview {
    SettingsView()
}
