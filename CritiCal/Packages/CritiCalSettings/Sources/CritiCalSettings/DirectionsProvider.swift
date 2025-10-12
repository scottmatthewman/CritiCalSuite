//
//  DirectionsProvider.swift
//  CritiCalSettings
//
//  Created by Scott Matthewman on 12/10/2025.
//

import Foundation
import Defaults

public enum DirectionsProvider: String, Codable, Sendable, CaseIterable, Defaults.Serializable {
    case appleMaps
    case citymapper
    case googleMaps
    case transit

    public var displayName: String {
        switch self {
        case .appleMaps: "Apple Maps"
        case .citymapper: "Citymapper"
        case .googleMaps: "Google Maps"
        case .transit: "Transit"
        }
    }
}
