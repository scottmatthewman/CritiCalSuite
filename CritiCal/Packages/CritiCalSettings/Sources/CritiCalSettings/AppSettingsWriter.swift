//
//  AppSettingsWriter.swift
//  CritiCalSettings
//
//  Created by Scott Matthewman on 11/10/2025.
//

import Defaults

/// Read-write access to app settings for AppSettings and Onboarding packages
public final class AppSettingsWriter: SettingsWritable, @unchecked Sendable {
    public static let shared = AppSettingsWriter()

    private init() {}

    public var completedOnboardingVersionNumber: Int? {
        Defaults[.completedOnboardingVersion]
    }

    public func setCompletedOnboardingVersionNumber(_ version: Int?) {
        Defaults[.completedOnboardingVersion] = version
    }

    public func resetOnboarding() {
        Defaults.reset(.completedOnboardingVersion)
    }

    public var preferredTransitMode: TransitMode {
        Defaults[.preferredTransitMode]
    }

    public func setPreferredTransitMode(_ mode: TransitMode) {
        Defaults[.preferredTransitMode] = mode
    }

    public var calculateTravelTime: Bool {
        Defaults[.calculateTravelTime]
    }

    public func setCalculateTravelTime(_ calculate: Bool) {
        Defaults[.calculateTravelTime] = calculate
    }
}
