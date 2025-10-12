//
//  TravelTimeLabel.swift
//  CritiCalMaps
//
//  Created by Scott Matthewman on 12/10/2025.
//

import CritiCalSettings
import MapKit
import SwiftUI

public struct TravelTimeLabel: View {
    private let travelTime: TimeInterval?
    private let transitMode: TransitMode
    private let locationError: Error?

    public init(
        travelTime: TimeInterval?,
        transitMode: TransitMode,
        locationError: Error?
    ) {
        self.travelTime = travelTime
        self.transitMode = transitMode
        self.locationError = locationError
    }

    public var body: some View {
        Label(labelText, systemImage: transitMode.symbolName)
            .foregroundStyle(.secondary)
            .labelIconToTitleSpacing(4)
    }

    private var labelText: String {
        if let error = locationError {
            return error.localizedDescription
        } else if let travelTime {
            return Duration
                .seconds(travelTime)
                .formatted(
                    .units(allowed: [.hours, .minutes], width: .abbreviated)
                )
        } else {
            return "Calculating…"
        }
    }
}
