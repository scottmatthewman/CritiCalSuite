//
//  SettingsKeys.swift
//  CritiCalSettings
//
//  Created by Scott Matthewman on 11/10/2025.
//

import Defaults

extension Defaults.Keys {
    /// The version of onboarding that was last completed (stored as Int)
    public static let completedOnboardingVersion = Key<Int?>(
        "onboardingVersion",
        default: nil
    )

    /// The user's preferred transit mode for directions
    public static let preferredTransitMode = Key<TransitMode>(
        "preferredTransitMode",
        default: .default
    )

    /// Whether to show transit times in-app
    public static let calculateTravelTime = Key<Bool>(
        "calculateTravelTime",
        default: true
    )

    /// Which app to use for directions
    public static let directionsProvider = Key<DirectionsProvider>(
        "directionsProvider",
        default: .appleMaps
    )
}
