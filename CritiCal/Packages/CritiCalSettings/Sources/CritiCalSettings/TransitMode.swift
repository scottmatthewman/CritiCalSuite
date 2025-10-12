//
//  TransitMode.swift
//  CritiCalSettings
//
//  Created by Scott Matthewman on 11/10/2025.
//

import Foundation
import Defaults

/// Preferred transit mode for directions
public enum TransitMode: String, Codable, Sendable, CaseIterable, Defaults.Serializable {
    case `default`
    case publicTransit
    case walking
    case driving
    case cycling

    /// Human-readable display name
    public var displayName: String {
        switch self {
        case .default: "App Default"
        case .publicTransit: "Public Transit"
        case .walking: "Walking"
        case .driving: "Driving"
        case .cycling: "Cycling"
        }
    }
}
