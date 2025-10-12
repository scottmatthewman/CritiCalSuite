//
//  AppSettingsReader.swift
//  CritiCalSettings
//
//  Created by Scott Matthewman on 11/10/2025.
//

import Defaults

/// Read-only access to app settings for most packages
public final class AppSettingsReader: SettingsReadable, @unchecked Sendable {
    public static let shared = AppSettingsReader()

    private init() {}

    public var completedOnboardingVersionNumber: Int? {
        Defaults[.completedOnboardingVersion]
    }

    public var preferredTransitMode: TransitMode {
        Defaults[.preferredTransitMode]
    }

    public var calculateTravelTime: Bool {
        Defaults[.calculateTravelTime]
    }
}
