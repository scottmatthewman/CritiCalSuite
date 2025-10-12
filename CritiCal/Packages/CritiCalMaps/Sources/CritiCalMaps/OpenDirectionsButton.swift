//
//  OpenDirectionsButton.swift
//  CritiCalMaps
//
//  Created by Scott Matthewman on 12/10/2025.
//

import CritiCalSettings
import MapKit
import SwiftUI

public struct OpenDirectionsButton: View {
    private var mapItem: MKMapItem

    @Environment(\.openURL) private var openURL
    @ReadOnlySetting(.preferredTransitMode) private var transitMode
    @ReadOnlySetting(.directionsProvider) private var directionsProvider

    public init(destination mapItem: MKMapItem) {
        self.mapItem = mapItem
    }

    public var body: some View {
        Button(
            "via \(directionsProvider.displayName)",
            systemImage: "arrow.triangle.turn.up.right.diamond"
        ) {
            directionsProvider
                .open(destination: mapItem, mode: transitMode, openURL: openURL)
        }
    }
}
