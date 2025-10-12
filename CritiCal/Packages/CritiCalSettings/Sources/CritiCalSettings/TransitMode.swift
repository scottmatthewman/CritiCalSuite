//
//  TransitMode.swift
//  CritiCalSettings
//
//  Created by Scott Matthewman on 11/10/2025.
//

import Foundation
import MapKit
import Defaults

/// Preferred transit mode for directions
public enum TransitMode: String, Codable, Sendable, CaseIterable, Defaults.Serializable {
    case `default`
    case publicTransit
    case walking
    case car
    case cycling

    /// Human-readable display name
    public var displayName: String {
        switch self {
        case .default: "App Default"
        case .publicTransit: "Public Transit"
        case .walking: "Walking"
        case .car: "Driving"
        case .cycling: "Cycling"
        }
    }

    /// Convert to MapKit transport type for directions
    public var mapKitTransportType: MKDirectionsTransportType {
        switch self {
        case .default: .any
        case .publicTransit: .transit
        case .walking: .walking
        case .car: .automobile
        case .cycling: .cycling
        }
    }

    /// System image name for SF Symbols
    public var symbolName: String {
        switch self {
        case .default: "arrow.triangle.turn.up.right.diamond"
        case .publicTransit: "tram"
        case .walking: "figure.walk"
        case .car: "car"
        case .cycling: "bicycle"
        }
    }
}
