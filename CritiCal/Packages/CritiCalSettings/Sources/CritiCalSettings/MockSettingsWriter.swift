//
//  MockSettingsWriter.swift
//  CritiCalSettings
//
//  Created by Scott Matthewman on 11/10/2025.
//

import Foundation
import Defaults

/// Mock settings writer for testing purposes
/// Allows injecting a custom UserDefaults suite for isolated testing
public final class MockSettingsWriter: SettingsWritable, @unchecked Sendable {
    private let suite: UserDefaults

    public init(suite: UserDefaults) {
        self.suite = suite
    }

    public var completedOnboardingVersionNumber: Int? {
        guard suite.object(forKey: Defaults.Keys.completedOnboardingVersion.name) != nil else {
            return nil
        }
        return suite.integer(forKey: Defaults.Keys.completedOnboardingVersion.name)
    }

    public func setCompletedOnboardingVersionNumber(_ version: Int?) {
        if let version = version {
            suite.set(version, forKey: Defaults.Keys.completedOnboardingVersion.name)
        } else {
            suite.removeObject(forKey: Defaults.Keys.completedOnboardingVersion.name)
        }
    }

    public func resetOnboarding() {
        suite.removeObject(forKey: Defaults.Keys.completedOnboardingVersion.name)
    }

    public var preferredTransitMode: TransitMode {
        guard let rawValue = suite.string(forKey: Defaults.Keys.preferredTransitMode.name),
              let mode = TransitMode(rawValue: rawValue) else {
            return .publicTransit // default
        }
        return mode
    }

    public func setPreferredTransitMode(_ mode: TransitMode) {
        suite.set(mode.rawValue, forKey: Defaults.Keys.preferredTransitMode.name)
    }

    public var calculateTravelTime: Bool {
        suite.bool(forKey: Defaults.Keys.calculateTravelTime.name)
    }
    public func setCalculateTravelTime(_ calculate: Bool) {
        suite.set(calculate, forKey: Defaults.Keys.calculateTravelTime.name)
    }
}
