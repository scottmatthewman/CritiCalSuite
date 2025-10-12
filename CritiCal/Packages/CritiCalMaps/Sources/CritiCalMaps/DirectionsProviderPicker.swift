//
//  DirectionsProviderPicker.swift
//  AppSettings
//
//  Created by Scott Matthewman on 12/10/2025.
//

import CritiCalSettings
import SwiftUI

public struct DirectionsProviderPicker: View {
    private var title: LocalizedStringKey
    @Binding private var selection: DirectionsProvider

    public init(
        _ title: LocalizedStringKey = "Directions Provider",
        selection: Binding<DirectionsProvider>
    ) {
        self.title = title
        self._selection = selection
    }

    public var body: some View {
        Picker("Directions Provider", selection: $selection) {
            ForEach(availableProviders, id: \.self) { provider in
                Text(provider.displayName)
                    .tag(provider)
            }
        }
    }

    private var availableProviders: [DirectionsProvider] {
        DirectionsProvider.allCases.filter(\.canBeUsedForDirections)
    }
}

#Preview {
    @Previewable @State var directionsProvider = DirectionsProvider.appleMaps
    Form {
        DirectionsProviderPicker("App", selection: $directionsProvider)
    }
}
