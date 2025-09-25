//
//  OnboardingSettings.swift
//  OnboardingFlow
//
//  Created by Scott Matthewman on 22/09/2025.
//

import SwiftUI

/// Manages the persistence of onboarding state
@Observable
public final class OnboardingSettings {
    private let userDefaults: UserDefaults
    private let onboardingVersionKey = "com.critical.onboardingVersion"

    /// The version of onboarding that was last completed
    @ObservationIgnored
    private var _completedVersion: OnboardingVersion?

    public var completedVersion: OnboardingVersion? {
        get {
            _completedVersion
        }
        set {
            _completedVersion = newValue
            saveCompletedVersion()
        }
    }

    /// Whether the current version of onboarding should be shown
    public var shouldShowOnboarding: Bool {
        guard let completedVersion else {
            // Never shown onboarding before
            return true
        }
        // Show if current version is newer than completed version
        return OnboardingVersion.current > completedVersion
    }

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self._completedVersion = loadCompletedVersion()
    }

    /// Mark the current version of onboarding as completed
    public func completeOnboarding() {
        completedVersion = OnboardingVersion.current
    }

    /// Reset onboarding (useful for testing)
    public func resetOnboarding() {
        completedVersion = nil
        userDefaults.removeObject(forKey: onboardingVersionKey)
    }

    // MARK: - Private

    private func loadCompletedVersion() -> OnboardingVersion? {
        guard let data = userDefaults.data(forKey: onboardingVersionKey),
              let version = try? JSONDecoder().decode(OnboardingVersion.self, from: data) else {
            return nil
        }
        return version
    }

    private func saveCompletedVersion() {
        if let version = _completedVersion,
           let data = try? JSONEncoder().encode(version) {
            userDefaults.set(data, forKey: onboardingVersionKey)
        } else {
            userDefaults.removeObject(forKey: onboardingVersionKey)
        }
    }
}