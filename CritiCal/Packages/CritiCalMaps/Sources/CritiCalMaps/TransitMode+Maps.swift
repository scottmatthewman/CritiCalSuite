//
//  TransitMode+SwiftUI.swift
//  CritiCalMaps
//
//  Created by Scott Matthewman on 12/10/2025.
//

import CritiCalSettings
import MapKit

extension TransitMode {
    /// Convert to MapKit transport type for directions
    internal var mapKitTransportType: MKDirectionsTransportType {
        switch self {
        case .default: .any
        case .publicTransit: .transit
        case .walking: .walking
        case .driving: .automobile
        case .cycling: .cycling
        }
    }

    /// System image name for SF Symbols
    internal var symbolName: String {
        switch self {
        case .default: "arrow.triangle.turn.up.right.diamond"
        case .publicTransit: "tram"
        case .walking: "figure.walk"
        case .driving: "car"
        case .cycling: "bicycle"
        }
    }

    internal var appleMapsDirectionsMode: String {
        switch self {
        case .default:
            MKLaunchOptionsDirectionsModeDefault
        case .cycling:
            MKLaunchOptionsDirectionsModeCycling
        case .driving:
            MKLaunchOptionsDirectionsModeDriving
        case .publicTransit:
            MKLaunchOptionsDirectionsModeTransit
        case .walking:
            MKLaunchOptionsDirectionsModeWalking
        }
    }

    internal var googleMapsMode: String? {
        switch self {
        case .publicTransit: "transit"
        case .walking: "walking"
        case .driving: "driving"
        case .cycling: "bicycling"
        default: nil
        }
    }
}
