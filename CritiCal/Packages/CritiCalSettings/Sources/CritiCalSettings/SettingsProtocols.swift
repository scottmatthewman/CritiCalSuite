//
//  SettingsProtocols.swift
//  CritiCalSettings
//
//  Created by Scott Matthewman on 11/10/2025.
//

import Foundation

/// Read-only access to app settings
public protocol SettingsReadable: Sendable {
    /// The raw version number of onboarding that was last completed
    var completedOnboardingVersionNumber: Int? { get }
}

/// Read-write access to app settings
public protocol SettingsWritable: SettingsReadable {
    /// Update the completed onboarding version number
    func setCompletedOnboardingVersionNumber(_ version: Int?)

    /// Reset onboarding state (useful for testing)
    func resetOnboarding()
}
