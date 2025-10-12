//
//  OnboardingSettings.swift
//  OnboardingFlow
//
//  Created by Scott Matthewman on 22/09/2025.
//

import SwiftUI
import CritiCalSettings

/// Manages the persistence of onboarding state
@Observable
public final class OnboardingSettings {
    private let settings: any SettingsWritable

    /// The version of onboarding that was last completed
    public var completedVersion: OnboardingVersion? {
        get {
            guard let versionNumber = settings.completedOnboardingVersionNumber else {
                return nil
            }
            return OnboardingVersion(version: versionNumber)
        }
        set {
            settings.setCompletedOnboardingVersionNumber(newValue?.version)
        }
    }

    /// Whether the current version of onboarding should be shown
    public var shouldShowOnboarding: Bool {
        guard let completedVersion else {
            return true
        }
        return OnboardingVersion.current > completedVersion
    }

    public init(settings: any SettingsWritable = AppSettingsWriter.shared) {
        self.settings = settings
    }

    /// Mark the current version of onboarding as completed
    public func completeOnboarding() {
        completedVersion = .current
    }

    /// Reset onboarding (useful for testing)
    public func resetOnboarding() {
        settings.resetOnboarding()
    }
}